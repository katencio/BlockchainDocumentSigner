'use client';

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { ethers } from 'ethers';

interface Wallet {
  address: string;
  privateKey: string;
}

interface MetaMaskContextType {
  wallets: Wallet[];
  currentWalletIndex: number | null;
  currentWallet: Wallet | null;
  provider: ethers.JsonRpcProvider | null;
  signer: ethers.Wallet | null;
  connect: (walletIndex: number) => void;
  disconnect: () => void;
  switchWallet: (walletIndex: number) => void;
  signMessage: (message: string) => Promise<string>;
  getSigner: () => Promise<ethers.Wallet>;
  isConnected: boolean;
}

const MetaMaskContext = createContext<MetaMaskContextType | undefined>(undefined);

// Derivar wallets desde mnemonic de Anvil
const ANVIL_MNEMONIC = process.env.NEXT_PUBLIC_MNEMONIC || "test test test test test test test test test test test junk";

const deriveWallets = (): Wallet[] => {
  return Array.from({ length: 10 }, (_, i) => {
    const path = `m/44'/60'/0'/0/${i}`;
    const wallet = ethers.HDNodeWallet.fromPhrase(ANVIL_MNEMONIC, undefined, path);
    return { address: wallet.address, privateKey: wallet.privateKey };
  });
};

// Crear JsonRpcProvider
const RPC_URL = process.env.NEXT_PUBLIC_RPC_URL || 'http://localhost:8545';
const provider = new ethers.JsonRpcProvider(RPC_URL);

export function MetaMaskProvider({ children }: { children: ReactNode }) {
  const [wallets] = useState<Wallet[]>(deriveWallets());
  const [currentWalletIndex, setCurrentWalletIndex] = useState<number | null>(null);
  const [signer, setSigner] = useState<ethers.Wallet | null>(null);

  const currentWallet = currentWalletIndex !== null ? wallets[currentWalletIndex] : null;
  const isConnected = currentWalletIndex !== null;

  const connect = (walletIndex: number) => {
    if (walletIndex < 0 || walletIndex >= wallets.length) {
      throw new Error('Invalid wallet index');
    }
    const wallet = new ethers.Wallet(wallets[walletIndex].privateKey, provider);
    setCurrentWalletIndex(walletIndex);
    setSigner(wallet);
  };

  const disconnect = () => {
    setCurrentWalletIndex(null);
    setSigner(null);
  };

  const switchWallet = (walletIndex: number) => {
    connect(walletIndex);
  };

  const signMessage = async (message: string): Promise<string> => {
    if (!signer) {
      throw new Error('No wallet connected');
    }
    return await signer.signMessage(message);
  };

  const getSigner = async (): Promise<ethers.Wallet> => {
    if (!signer) {
      throw new Error('No wallet connected');
    }
    return signer;
  };

  return (
    <MetaMaskContext.Provider
      value={{
        wallets,
        currentWalletIndex,
        currentWallet,
        provider,
        signer,
        connect,
        disconnect,
        switchWallet,
        signMessage,
        getSigner,
        isConnected,
      }}
    >
      {children}
    </MetaMaskContext.Provider>
  );
}

export function useMetaMask() {
  const context = useContext(MetaMaskContext);
  if (context === undefined) {
    throw new Error('useMetaMask must be used within a MetaMaskProvider');
  }
  return context;
}

