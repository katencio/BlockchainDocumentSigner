// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {DocumentRegistry} from "../src/DocumentRegistry.sol";

contract DocumentRegistryTest is Test {
    DocumentRegistry public registry;
    
    // Datos de prueba
    bytes32 public constant TEST_HASH = keccak256("test document");
    bytes32 public constant TEST_HASH_2 = keccak256("test document 2");
    bytes32 public constant NON_EXISTENT_HASH = keccak256("non existent");
    
    address public signer;
    address public user;
    
    bytes public signature;
    bytes public signature2;
    
    uint256 public timestamp;

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

    function setUp() public {
        registry = new DocumentRegistry();
        
        signer = address(0x1);
        user = address(0x2);
        
        signature = "0x1234567890abcdef";
        signature2 = "0xabcdef1234567890";
        
        timestamp = block.timestamp;
    }

    // ============ Tests de Almacenamiento ============

    /**
     * @dev Test: Almacenar documento correctamente
     */
    function test_StoreDocumentHash_Success() public {
        vm.expectEmit(true, true, false, true);
        emit DocumentStored(TEST_HASH, signer, timestamp);
        
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Verificar que el documento fue almacenado
        assertTrue(registry.isDocumentStored(TEST_HASH));
        assertEq(registry.getDocumentCount(), 1);
        
        // Verificar información del documento
        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH);
        assertEq(doc.hash, TEST_HASH);
        assertEq(doc.timestamp, timestamp);
        assertEq(doc.signer, signer);
        assertEq(keccak256(doc.signature), keccak256(signature));
    }

    /**
     * @dev Test: Rechazar documentos duplicados
     */
    function test_StoreDocumentHash_RejectDuplicate() public {
        // Almacenar primer documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Intentar almacenar el mismo documento de nuevo
        vm.expectRevert("Document already exists");
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp + 1,
            signature2,
            user
        );
        
        // Verificar que solo hay un documento
        assertEq(registry.getDocumentCount(), 1);
    }

    /**
     * @dev Test: Rechazar hash inválido (bytes32(0))
     */
    function test_StoreDocumentHash_RejectInvalidHash() public {
        vm.expectRevert("Invalid document hash");
        registry.storeDocumentHash(
            bytes32(0),
            timestamp,
            signature,
            signer
        );
    }

    /**
     * @dev Test: Rechazar signer inválido (address(0))
     */
    function test_StoreDocumentHash_RejectInvalidSigner() public {
        vm.expectRevert("Invalid signer address");
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            address(0)
        );
    }

    // ============ Tests de Verificación ============

    /**
     * @dev Test: Verificar documento existente correctamente
     */
    function test_VerifyDocument_Success() public {
        // Almacenar documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Verificar documento
        vm.expectEmit(true, true, false, true);
        emit DocumentVerified(TEST_HASH, signer, true);
        
        bool verified = registry.verifyDocument(TEST_HASH, signer, signature);
        assertTrue(verified);
    }

    /**
     * @dev Test: Verificar documento con signer incorrecto
     */
    function test_VerifyDocument_WrongSigner() public {
        // Almacenar documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Verificar con signer incorrecto
        vm.expectEmit(true, true, false, true);
        emit DocumentVerified(TEST_HASH, user, false);
        
        bool verified = registry.verifyDocument(TEST_HASH, user, signature);
        assertFalse(verified);
    }

    /**
     * @dev Test: Verificar documento con signature incorrecta
     */
    function test_VerifyDocument_WrongSignature() public {
        // Almacenar documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Verificar con signature incorrecta
        vm.expectEmit(true, true, false, true);
        emit DocumentVerified(TEST_HASH, signer, false);
        
        bool verified = registry.verifyDocument(TEST_HASH, signer, signature2);
        assertFalse(verified);
    }

    /**
     * @dev Test: Rechazar verificación de documento inexistente
     */
    function test_VerifyDocument_NonExistent() public {
        vm.expectRevert("Document does not exist");
        registry.verifyDocument(NON_EXISTENT_HASH, signer, signature);
    }

    // ============ Tests de Obtención de Información ============

    /**
     * @dev Test: Obtener información correcta
     */
    function test_GetDocumentInfo_Success() public {
        // Almacenar documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Obtener información
        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH);
        
        assertEq(doc.hash, TEST_HASH);
        assertEq(doc.timestamp, timestamp);
        assertEq(doc.signer, signer);
        assertEq(keccak256(doc.signature), keccak256(signature));
    }

    /**
     * @dev Test: Rechazar obtener información de documento inexistente
     */
    function test_GetDocumentInfo_NonExistent() public {
        vm.expectRevert("Document does not exist");
        registry.getDocumentInfo(NON_EXISTENT_HASH);
    }

    // ============ Tests de Verificación de Existencia ============

    /**
     * @dev Test: Verificar si documento está almacenado (existe)
     */
    function test_IsDocumentStored_Exists() public {
        // Almacenar documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        assertTrue(registry.isDocumentStored(TEST_HASH));
    }

    /**
     * @dev Test: Verificar si documento está almacenado (no existe)
     */
    function test_IsDocumentStored_NotExists() public {
        assertFalse(registry.isDocumentStored(NON_EXISTENT_HASH));
    }

    // ============ Tests de Contador ============

    /**
     * @dev Test: Contar documentos
     */
    function test_GetDocumentCount() public {
        // Inicialmente debe ser 0
        assertEq(registry.getDocumentCount(), 0);
        
        // Almacenar primer documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        assertEq(registry.getDocumentCount(), 1);
        
        // Almacenar segundo documento
        registry.storeDocumentHash(
            TEST_HASH_2,
            timestamp + 1,
            signature2,
            user
        );
        assertEq(registry.getDocumentCount(), 2);
    }

    // ============ Tests de Iteración por Índice ============

    /**
     * @dev Test: Obtener hash por índice
     */
    function test_GetDocumentHashByIndex_Success() public {
        // Almacenar múltiples documentos
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        registry.storeDocumentHash(
            TEST_HASH_2,
            timestamp + 1,
            signature2,
            user
        );
        
        // Verificar que se pueden obtener por índice
        assertEq(registry.getDocumentHashByIndex(0), TEST_HASH);
        assertEq(registry.getDocumentHashByIndex(1), TEST_HASH_2);
    }

    /**
     * @dev Test: Rechazar índice fuera de rango
     */
    function test_GetDocumentHashByIndex_OutOfBounds() public {
        // Almacenar un documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Intentar acceder a índice fuera de rango
        vm.expectRevert("Index out of bounds");
        registry.getDocumentHashByIndex(1);
    }

    /**
     * @dev Test: Iterar sobre todos los documentos
     */
    function test_IterateAllDocuments() public {
        // Almacenar múltiples documentos
        bytes32[] memory hashes = new bytes32[](3);
        hashes[0] = keccak256("doc1");
        hashes[1] = keccak256("doc2");
        hashes[2] = keccak256("doc3");
        
        for (uint256 i = 0; i < hashes.length; i++) {
            registry.storeDocumentHash(
                hashes[i],
                timestamp + i,
                signature,
                signer
            );
        }
        
        // Verificar que se pueden iterar todos
        assertEq(registry.getDocumentCount(), 3);
        for (uint256 i = 0; i < hashes.length; i++) {
            assertEq(registry.getDocumentHashByIndex(i), hashes[i]);
        }
    }

    // ============ Tests de Optimización ============

    /**
     * @dev Test: Verificar que se usa signer != address(0) para existencia
     */
    function test_Optimization_UseSignerForExistence() public {
        // Documento no debe existir inicialmente
        assertFalse(registry.isDocumentStored(TEST_HASH));
        
        // Almacenar documento
        registry.storeDocumentHash(
            TEST_HASH,
            timestamp,
            signature,
            signer
        );
        
        // Ahora debe existir
        assertTrue(registry.isDocumentStored(TEST_HASH));
        
        // Verificar que el signer no es address(0)
        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH);
        assertNotEq(doc.signer, address(0));
    }
}

