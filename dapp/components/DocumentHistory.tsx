'use client';

import React, { useState, useEffect } from 'react';
import { History, Loader2, RefreshCw } from 'lucide-react';
import { useContract } from '@/hooks/useContract';

interface DocumentInfo {
  hash: string;
  timestamp: string;
  signer: string;
  signature: string;
}

export default function DocumentHistory() {
  const { getDocumentCount, getDocumentHashByIndex, getDocumentInfo } = useContract();
  const [documents, setDocuments] = useState<DocumentInfo[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string>('');

  const loadDocuments = async () => {
    setIsLoading(true);
    setError('');
    try {
      const count = await getDocumentCount();
      const docs: DocumentInfo[] = [];

      for (let i = 0; i < count; i++) {
        try {
          const hash = await getDocumentHashByIndex(i);
          const info = await getDocumentInfo(hash);
          docs.push({
            hash,
            timestamp: info.timestamp,
            signer: info.signer,
            signature: info.signature,
          });
        } catch (err) {
          console.error(`Error loading document at index ${i}:`, err);
        }
      }

      setDocuments(docs);
    } catch (err: any) {
      setError(err.message || 'Error al cargar el historial');
      console.error('Error loading documents:', err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadDocuments();
  }, []);

  const formatAddress = (address: string) => {
    return `${address.substring(0, 6)}...${address.substring(address.length - 4)}`;
  };

  const formatSignature = (signature: string) => {
    return `${signature.substring(0, 10)}...${signature.substring(signature.length - 10)}`;
  };

  return (
    <div className="w-full">
      <div className="p-6 bg-white border border-gray-200 rounded-lg">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold flex items-center gap-2">
            <History className="h-5 w-5" />
            Historial de Documentos
          </h3>
          <button
            onClick={loadDocuments}
            disabled={isLoading}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center gap-2"
          >
            <RefreshCw className={`h-4 w-4 ${isLoading ? 'animate-spin' : ''}`} />
            Actualizar
          </button>
        </div>

        {isLoading && (
          <div className="text-center py-8">
            <Loader2 className="h-8 w-8 animate-spin mx-auto text-blue-600 mb-2" />
            <p className="text-gray-600">Cargando documentos...</p>
          </div>
        )}

        {error && (
          <div className="p-4 bg-red-50 border border-red-200 rounded-lg mb-4">
            <p className="text-red-800 text-sm">{error}</p>
          </div>
        )}

        {!isLoading && !error && documents.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            <History className="h-12 w-12 mx-auto mb-4 text-gray-400" />
            <p>No hay documentos almacenados</p>
          </div>
        )}

        {!isLoading && documents.length > 0 && (
          <div className="overflow-x-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr className="border-b border-gray-200">
                  <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                    Hash del Documento
                  </th>
                  <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                    Firmante
                  </th>
                  <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                    Timestamp
                  </th>
                  <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">
                    Firma
                  </th>
                </tr>
              </thead>
              <tbody>
                {documents.map((doc, index) => (
                  <tr
                    key={index}
                    className="border-b border-gray-100 hover:bg-gray-50 transition-colors"
                  >
                    <td className="py-3 px-4">
                      <div className="font-mono text-xs text-gray-600 break-all max-w-xs">
                        {doc.hash}
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="font-mono text-xs text-blue-600">
                        {formatAddress(doc.signer)}
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="text-sm text-gray-600">
                        {new Date(Number(doc.timestamp) * 1000).toLocaleString()}
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="font-mono text-xs text-gray-500">
                        {formatSignature(doc.signature)}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {!isLoading && documents.length > 0 && (
          <div className="mt-4 text-sm text-gray-600">
            Total: {documents.length} documento(s)
          </div>
        )}
      </div>
    </div>
  );
}

