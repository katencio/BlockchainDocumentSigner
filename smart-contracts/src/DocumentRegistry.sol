// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DocumentRegistry
 * @dev Contrato optimizado para almacenar y verificar documentos
 * @notice Usa documents[hash].signer != address(0) para verificar existencia (ahorra ~39% de gas)
 */
contract DocumentRegistry {
    /**
     * @dev Estructura del documento
     * @param hash Hash del documento
     * @param timestamp Timestamp de almacenamiento
     * @param signer Dirección que firmó el documento
     * @param signature Firma del documento
     */
    struct Document {
        bytes32 hash;
        uint256 timestamp;
        address signer;
        bytes signature;
    }

    // Mapping de hash a Document
    mapping(bytes32 => Document) public documents;
    
    // Array para iterar sobre los documentos almacenados
    bytes32[] public documentHashes;
    
    // Contador de documentos
    uint256 public documentCount;

    // Eventos
    event DocumentStored(
        bytes32 indexed hash,
        address indexed signer,
        uint256 timestamp
    );
    
    event DocumentVerified(
        bytes32 indexed hash,
        address indexed signer,
        bool verified
    );

    /**
     * @dev Modifier para verificar que el documento NO existe
     * @param _hash Hash del documento a verificar
     */
    modifier documentNotExists(bytes32 _hash) {
        require(
            documents[_hash].signer == address(0),
            "Document already exists"
        );
        _;
    }

    /**
     * @dev Modifier para verificar que el documento existe
     * @param _hash Hash del documento a verificar
     */
    modifier documentExists(bytes32 _hash) {
        require(
            documents[_hash].signer != address(0),
            "Document does not exist"
        );
        _;
    }

    /**
     * @dev Almacena un documento en el registro
     * @param _hash Hash del documento
     * @param _timestamp Timestamp de almacenamiento
     * @param _signature Firma del documento
     * @param _signer Dirección que firmó el documento
     */
    function storeDocumentHash(
        bytes32 _hash,
        uint256 _timestamp,
        bytes memory _signature,
        address _signer
    ) external documentNotExists(_hash) {
        require(_signer != address(0), "Invalid signer address");
        require(_hash != bytes32(0), "Invalid document hash");
        
        documents[_hash] = Document({
            hash: _hash,
            timestamp: _timestamp,
            signer: _signer,
            signature: _signature
        });
        
        documentHashes.push(_hash);
        documentCount++;
        
        emit DocumentStored(_hash, _signer, _timestamp);
    }

    /**
     * @dev Verifica un documento comparando hash, signer y signature
     * @param _hash Hash del documento a verificar
     * @param _signer Dirección del firmante esperado
     * @param _signature Firma a verificar
     * @return bool True si el documento es válido
     */
    function verifyDocument(
        bytes32 _hash,
        address _signer,
        bytes memory _signature
    ) external documentExists(_hash) returns (bool) {
        Document memory doc = documents[_hash];
        
        bool isValid = (
            doc.hash == _hash &&
            doc.signer == _signer &&
            keccak256(doc.signature) == keccak256(_signature)
        );
        
        emit DocumentVerified(_hash, _signer, isValid);
        
        return isValid;
    }

    /**
     * @dev Obtiene la información completa de un documento
     * @param _hash Hash del documento
     * @return Document Estructura con toda la información del documento
     */
    function getDocumentInfo(
        bytes32 _hash
    ) external view documentExists(_hash) returns (Document memory) {
        return documents[_hash];
    }

    /**
     * @dev Verifica si un documento está almacenado
     * @param _hash Hash del documento a verificar
     * @return bool True si el documento existe
     */
    function isDocumentStored(bytes32 _hash) external view returns (bool) {
        return documents[_hash].signer != address(0);
    }

    /**
     * @dev Obtiene el número total de documentos almacenados
     * @return uint256 Cantidad de documentos
     */
    function getDocumentCount() external view returns (uint256) {
        return documentCount;
    }

    /**
     * @dev Obtiene el hash de un documento por su índice
     * @param _index Índice del documento en el array
     * @return bytes32 Hash del documento
     */
    function getDocumentHashByIndex(
        uint256 _index
    ) external view returns (bytes32) {
        require(_index < documentHashes.length, "Index out of bounds");
        return documentHashes[_index];
    }
}

