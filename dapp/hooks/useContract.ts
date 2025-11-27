'use client';

import { ethers } from 'ethers';
import { useMetaMask } from '@/contexts/MetaMaskContext';
import { useMemo } from 'react';

// ABI del contrato DocumentRegistry (optimizado)
const CONTRACT_ABI = [
  "function storeDocumentHash(bytes32 _hash, uint256 _timestamp, bytes calldata _signature, address _signer) external",
  "function getDocumentInfo(bytes32 _hash) external view returns (uint256 timestamp, address signer, bytes memory signature)",
  "function isDocumentStored(bytes32 _hash) external view returns (bool)",
  "function getDocumentCount() external view returns (uint256)",
  "function getDocumentHashByIndex(uint256 _index) external view returns (bytes32)",
  "function verifyDocument(bytes32 _hash, address _signer, bytes calldata _signature) external returns (bool)",
  "event DocumentStored(bytes32 indexed hash, address indexed signer, uint256 timestamp)",
  "event DocumentVerified(bytes32 indexed hash, address indexed signer, bool verified)"
];

const CONTRACT_ADDRESS = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS || '';

export function useContract() {
  const { provider, getSigner, isConnected } = useMetaMask();

  const contract = useMemo(() => {
    if (!provider || !CONTRACT_ADDRESS) {
      return null;
    }
    return new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, provider);
  }, [provider]);

  const storeDocumentHash = async (
    hash: string,
    timestamp: number,
    signature: string,
    signerAddress: string
  ) => {
    if (!contract || !isConnected) {
      throw new Error('Contract not available or wallet not connected');
    }

    const signer = await getSigner();
    const contractWithSigner = contract.connect(signer);
    
    const tx = await contractWithSigner.storeDocumentHash(
      hash,
      timestamp,
      signature,
      signerAddress
    );
    
    await tx.wait();
    return tx;
  };

  const getDocumentInfo = async (hash: string) => {
    if (!contract) {
      throw new Error('Contract not available');
    }

    // Ahora getDocumentInfo retorna (timestamp, signer, signature) en lugar de struct
    const [timestamp, signer, signature] = await contract.getDocumentInfo(hash);
    return {
      hash: hash, // El hash se pasa como parámetro, no se retorna del contrato
      timestamp: timestamp.toString(),
      signer: signer,
      signature: signature,
    };
  };

  const isDocumentStored = async (hash: string): Promise<boolean> => {
    if (!contract) {
      throw new Error('Contract not available');
    }

    return await contract.isDocumentStored(hash);
  };

  const getDocumentCount = async (): Promise<number> => {
    if (!contract) {
      throw new Error('Contract not available');
    }

    const count = await contract.getDocumentCount();
    return Number(count.toString());
  };

  const getDocumentHashByIndex = async (index: number): Promise<string> => {
    if (!contract) {
      throw new Error('Contract not available');
    }

    return await contract.getDocumentHashByIndex(index);
  };

  const verifyDocument = async (
    hash: string,
    signerAddress: string,
    signature: string
  ): Promise<boolean> => {
    if (!contract || !isConnected) {
      throw new Error('Contract not available or wallet not connected');
    }

    const signer = await getSigner();
    const contractWithSigner = contract.connect(signer);
    
    return await contractWithSigner.verifyDocument(hash, signerAddress, signature);
  };

  return {
    contract,
    storeDocumentHash,
    getDocumentInfo,
    isDocumentStored,
    getDocumentCount,
    getDocumentHashByIndex,
    verifyDocument,
    isConnected,
  };
}

