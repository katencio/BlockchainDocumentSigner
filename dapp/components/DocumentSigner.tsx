'use client';

import React, { useState } from 'react';
import { FileSignature, CheckCircle, XCircle, Loader2 } from 'lucide-react';
import { useMetaMask } from '@/contexts/MetaMaskContext';
import { useContract } from '@/hooks/useContract';

interface DocumentSignerProps {
  documentHash: string;
}

export default function DocumentSigner({ documentHash }: DocumentSignerProps) {
  const { signMessage, currentWallet, isConnected } = useMetaMask();
  const { storeDocumentHash } = useContract();
  const [signature, setSignature] = useState<string>('');
  const [isSigning, setIsSigning] = useState(false);
  const [isStoring, setIsStoring] = useState(false);
  const [txHash, setTxHash] = useState<string>('');
  const [error, setError] = useState<string>('');

  const handleSign = async () => {
    if (!isConnected || !currentWallet) {
      alert('Por favor, conecta una wallet primero');
      return;
    }

    if (!documentHash) {
      alert('No hay hash de documento para firmar');
      return;
    }

    const confirmMessage = `¿Deseas firmar el siguiente hash?\n\n${documentHash}\n\nFirmante: ${currentWallet.address}`;
    if (!confirm(confirmMessage)) {
      return;
    }

    setIsSigning(true);
    setError('');
    try {
      const sig = await signMessage(documentHash);
      setSignature(sig);
      alert(`Firma generada exitosamente:\n\n${sig}`);
    } catch (err: any) {
      setError(err.message || 'Error al firmar el documento');
      alert('Error al firmar el documento: ' + err.message);
    } finally {
      setIsSigning(false);
    }
  };

  const handleStoreOnBlockchain = async () => {
    if (!isConnected || !currentWallet) {
      alert('Por favor, conecta una wallet primero');
      return;
    }

    if (!signature) {
      alert('Por favor, firma el documento primero');
      return;
    }

    if (!documentHash) {
      alert('No hay hash de documento para almacenar');
      return;
    }

    const confirmMessage = `¿Deseas almacenar este documento en la blockchain?\n\nHash: ${documentHash}\nFirmante: ${currentWallet.address}\n\nEsto enviará una transacción a la blockchain.`;
    if (!confirm(confirmMessage)) {
      return;
    }

    setIsStoring(true);
    setError('');
    try {
      const timestamp = Math.floor(Date.now() / 1000);
      const tx = await storeDocumentHash(
        documentHash,
        timestamp,
        signature,
        currentWallet.address
      );
      setTxHash(tx.hash);
      alert(`Documento almacenado exitosamente!\n\nHash de transacción: ${tx.hash}`);
    } catch (err: any) {
      setError(err.message || 'Error al almacenar el documento');
      alert('Error al almacenar el documento: ' + err.message);
    } finally {
      setIsStoring(false);
    }
  };

  if (!documentHash) {
    return (
      <div className="p-6 bg-gray-50 rounded-lg text-center text-gray-500">
        <FileSignature className="mx-auto h-12 w-12 mb-4 text-gray-400" />
        <p>Sube un archivo primero para firmarlo</p>
      </div>
    );
  }

  return (
    <div className="w-full space-y-4">
      <div className="p-6 bg-white border border-gray-200 rounded-lg">
        <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
          <FileSignature className="h-5 w-5" />
          Firmar Documento
        </h3>

        <div className="mb-4 p-4 bg-gray-50 rounded-lg">
          <p className="text-sm font-medium text-gray-700 mb-1">Hash del documento:</p>
          <p className="text-xs font-mono text-gray-600 break-all">{documentHash}</p>
        </div>

        {currentWallet && (
          <div className="mb-4 p-4 bg-blue-50 rounded-lg">
            <p className="text-sm font-medium text-gray-700 mb-1">Firmante:</p>
            <p className="text-xs font-mono text-blue-600">{currentWallet.address}</p>
          </div>
        )}

        {!signature ? (
          <button
            onClick={handleSign}
            disabled={!isConnected || isSigning}
            className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            {isSigning ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                Firmando...
              </>
            ) : (
              <>
                <FileSignature className="h-4 w-4" />
                Firmar Documento
              </>
            )}
          </button>
        ) : (
          <div className="space-y-4">
            <div className="p-4 bg-green-50 rounded-lg">
              <div className="flex items-center gap-2 mb-2">
                <CheckCircle className="h-5 w-5 text-green-600" />
                <p className="text-sm font-medium text-green-800">Firma generada</p>
              </div>
              <p className="text-xs font-mono text-green-700 break-all">{signature}</p>
            </div>

            <button
              onClick={handleStoreOnBlockchain}
              disabled={!isConnected || isStoring}
              className="w-full px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {isStoring ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin" />
                  Almacenando...
                </>
              ) : (
                <>
                  <CheckCircle className="h-4 w-4" />
                  Almacenar en Blockchain
                </>
              )}
            </button>
          </div>
        )}

        {txHash && (
          <div className="mt-4 p-4 bg-green-50 rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <CheckCircle className="h-5 w-5 text-green-600" />
              <p className="text-sm font-medium text-green-800">Transacción exitosa</p>
            </div>
            <p className="text-xs font-mono text-green-700 break-all">
              TX Hash: {txHash}
            </p>
          </div>
        )}

        {error && (
          <div className="mt-4 p-4 bg-red-50 rounded-lg">
            <div className="flex items-center gap-2 mb-2">
              <XCircle className="h-5 w-5 text-red-600" />
              <p className="text-sm font-medium text-red-800">Error</p>
            </div>
            <p className="text-xs text-red-700">{error}</p>
          </div>
        )}
      </div>
    </div>
  );
}

