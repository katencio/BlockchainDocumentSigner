// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DocumentRegistry
 * @dev Contrato optimizado para almacenar y verificar documentos
 * @notice Optimizaciones: elimina hash redundante, usa calldata, storage pointers y unchecked
 */
contract DocumentRegistry {
    /**
     * @dev Estructura del documento optimizada
     * @notice hash eliminado (redundante, ya es la clave del mapping)
     * @param timestamp Timestamp de almacenamiento
     * @param signer Dirección que firmó el documento
     * @param signature Firma del documento
     */
    struct Document {
        uint256 timestamp;
        address signer;
        bytes signature;
    }

    // Mapping de hash a Document
    mapping(bytes32 => Document) public documents;
    
    // Array para iterar sobre los documentos almacenados
    bytes32[] public documentHashes;

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
     * @notice Optimizaciones: usa calldata, elimina hash redundante, unchecked increment
     */
    function storeDocumentHash(
        bytes32 _hash,
        uint256 _timestamp,
        bytes calldata _signature,
        address _signer
    ) external documentNotExists(_hash) {
        require(_signer != address(0), "Invalid signer address");
        require(_hash != bytes32(0), "Invalid document hash");
        
        documents[_hash] = Document({
            timestamp: _timestamp,
            signer: _signer,
            signature: _signature
        });
        
        documentHashes.push(_hash);
        
        // Unchecked es seguro porque documentHashes.length nunca puede overflow
        unchecked {
            // documentCount eliminado, usar documentHashes.length en su lugar
        }
        
        emit DocumentStored(_hash, _signer, _timestamp);
    }

    /**
     * @dev Verifica un documento comparando signer y signature
     * @param _hash Hash del documento a verificar
     * @param _signer Dirección del firmante esperado
     * @param _signature Firma a verificar
     * @return bool True si el documento es válido
     * @notice Optimizaciones: usa storage pointer, calldata, elimina verificación redundante de hash
     */
    function verifyDocument(
        bytes32 _hash,
        address _signer,
        bytes calldata _signature
    ) external documentExists(_hash) returns (bool) {
        // Usar storage pointer en lugar de memory para ahorrar gas
        Document storage doc = documents[_hash];
        
        // Eliminada verificación redundante: doc.hash == _hash (hash ya está verificado por modifier)
        bool isValid = (
            doc.signer == _signer &&
            keccak256(doc.signature) == keccak256(_signature)
        );
        
        emit DocumentVerified(_hash, _signer, isValid);
        
        return isValid;
    }

    /**
     * @dev Obtiene la información completa de un documento
     * @param _hash Hash del documento
     * @return timestamp Timestamp de almacenamiento
     * @return signer Dirección del firmante
     * @return signature Firma del documento
     * @notice Optimizado: retorna valores individuales en lugar de struct completo
     */
    function getDocumentInfo(
        bytes32 _hash
    ) external view documentExists(_hash) returns (
        uint256 timestamp,
        address signer,
        bytes memory signature
    ) {
        Document storage doc = documents[_hash];
        return (doc.timestamp, doc.signer, doc.signature);
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
     * @notice Optimizado: usa documentHashes.length en lugar de mantener contador separado
     */
    function getDocumentCount() external view returns (uint256) {
        return documentHashes.length;
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

