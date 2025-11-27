'use client';

import React, { useState } from 'react';
import { Wallet, Upload, Shield, History } from 'lucide-react';
import { useMetaMask } from '@/contexts/MetaMaskContext';
import FileUploader from '@/components/FileUploader';
import DocumentSigner from '@/components/DocumentSigner';
import DocumentVerifier from '@/components/DocumentVerifier';
import DocumentHistory from '@/components/DocumentHistory';

const tabs = [
  { id: 'upload', label: 'Upload & Sign', icon: Upload },
  { id: 'verify', label: 'Verify', icon: Shield },
  { id: 'history', label: 'History', icon: History },
];

export default function Home() {
  const { wallets, currentWalletIndex, connect, disconnect, isConnected } = useMetaMask();
  const [activeTab, setActiveTab] = useState('upload');
  const [documentHash, setDocumentHash] = useState<string>('');

  const handleHashCalculated = (hash: string) => {
    setDocumentHash(hash);
  };

  const handleConnect = (walletIndex: number) => {
    connect(walletIndex);
  };

  const formatAddress = (address: string) => {
    return `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Wallet className="h-8 w-8 text-blue-600" />
              <h1 className="text-2xl font-bold text-gray-900">
                Document Sign Storage
              </h1>
            </div>

            {/* Wallet Selector */}
            <div className="flex items-center gap-4">
              {!isConnected ? (
                <div className="flex items-center gap-2">
                  <select
                    onChange={(e) => {
                      if (e.target.value) {
                        handleConnect(Number(e.target.value));
                      }
                    }}
                    className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    defaultValue=""
                  >
                    <option value="">Seleccionar Wallet</option>
                    {wallets.map((wallet, index) => (
                      <option key={index} value={index}>
                        Wallet {index + 1}: {formatAddress(wallet.address)}
                      </option>
                    ))}
                  </select>
                  <button
                    onClick={() => {
                      if (wallets.length > 0) {
                        handleConnect(0);
                      }
                    }}
                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                  >
                    Conectar
                  </button>
                </div>
              ) : (
                <div className="flex items-center gap-4">
                  <div className="flex items-center gap-2 px-4 py-2 bg-green-50 border border-green-200 rounded-lg">
                    <div className="h-2 w-2 bg-green-500 rounded-full"></div>
                    <span className="text-sm font-medium text-green-800">
                      Conectado
                    </span>
                  </div>
                  <div className="px-4 py-2 bg-gray-100 rounded-lg">
                    <span className="text-sm font-mono text-gray-700">
                      {currentWalletIndex !== null &&
                        formatAddress(wallets[currentWalletIndex].address)}
                    </span>
                  </div>
                  <select
                    onChange={(e) => {
                      if (e.target.value) {
                        handleConnect(Number(e.target.value));
                      }
                    }}
                    value={currentWalletIndex || ''}
                    className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    {wallets.map((wallet, index) => (
                      <option key={index} value={index}>
                        Wallet {index + 1}
                      </option>
                    ))}
                  </select>
                  <button
                    onClick={disconnect}
                    className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
                  >
                    Desconectar
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Tabs */}
        <div className="mb-6 border-b border-gray-200">
          <nav className="flex space-x-8">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center gap-2 py-4 px-1 border-b-2 font-medium text-sm transition-colors ${
                    activeTab === tab.id
                      ? 'border-blue-500 text-blue-600'
                      : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                  }`}
                >
                  <Icon className="h-5 w-5" />
                  {tab.label}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Tab Content */}
        <div className="mt-8">
          {activeTab === 'upload' && (
            <div className="space-y-6">
              <div className="bg-white rounded-lg shadow-sm p-6">
                <h2 className="text-xl font-semibold mb-4">Subir y Firmar Documento</h2>
                <FileUploader onHashCalculated={handleHashCalculated} />
              </div>
              {documentHash && (
                <div className="bg-white rounded-lg shadow-sm p-6">
                  <DocumentSigner documentHash={documentHash} />
                </div>
              )}
            </div>
          )}

          {activeTab === 'verify' && (
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h2 className="text-xl font-semibold mb-4">Verificar Documento</h2>
              <DocumentVerifier />
            </div>
          )}

          {activeTab === 'history' && (
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h2 className="text-xl font-semibold mb-4">Historial de Documentos</h2>
              <DocumentHistory />
            </div>
          )}
        </div>
      </main>

      {/* Footer */}
      <footer className="mt-12 border-t border-gray-200 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <p className="text-center text-sm text-gray-500">
            Document Sign Storage dApp - Desarrollado con Next.js y Ethers.js
          </p>
        </div>
      </footer>
    </div>
  );
}

