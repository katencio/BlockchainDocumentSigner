'use client';

import React, { useState } from 'react';
import { Shield, CheckCircle, XCircle, Loader2, Upload } from 'lucide-react';
import { ethers } from 'ethers';
import { useContract } from '@/hooks/useContract';

export default function DocumentVerifier() {
  const { isDocumentStored, getDocumentInfo } = useContract();
  const [file, setFile] = useState<File | null>(null);
  const [signerAddress, setSignerAddress] = useState<string>('');
  const [hash, setHash] = useState<string>('');
  const [isVerifying, setIsVerifying] = useState(false);
  const [verificationResult, setVerificationResult] = useState<{
    isValid: boolean;
    message: string;
    documentInfo?: any;
  } | null>(null);

  const calculateHash = async (file: File) => {
    const arrayBuffer = await file.arrayBuffer();
    const uint8Array = new Uint8Array(arrayBuffer);
    // Convert Uint8Array to hex string for keccak256
    const hexString = ethers.hexlify(uint8Array);
    return ethers.keccak256(hexString);
  };

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (selectedFile) {
      setFile(selectedFile);
      const calculatedHash = await calculateHash(selectedFile);
      setHash(calculatedHash);
    }
  };

  const handleVerify = async () => {
    if (!file) {
      alert('Por favor, selecciona un archivo');
      return;
    }

    if (!signerAddress) {
      alert('Por favor, ingresa la dirección del firmante');
      return;
    }

    if (!ethers.isAddress(signerAddress)) {
      alert('Dirección de firmante inválida');
      return;
    }

    setIsVerifying(true);
    setVerificationResult(null);

    try {
      // Calcular hash si no está calculado
      let documentHash = hash;
      if (!documentHash) {
        documentHash = await calculateHash(file);
        setHash(documentHash);
      }

      // Verificar si el documento está almacenado
      const isStored = await isDocumentStored(documentHash);

      if (!isStored) {
        setVerificationResult({
          isValid: false,
          message: 'El documento no está almacenado en la blockchain',
        });
        return;
      }

      // Obtener información del documento
      const docInfo = await getDocumentInfo(documentHash);

      // Comparar firmante
      const isValid = docInfo.signer.toLowerCase() === signerAddress.toLowerCase();

      setVerificationResult({
        isValid,
        message: isValid
          ? 'El documento es válido y coincide con el firmante'
          : 'El documento está almacenado pero el firmante no coincide',
        documentInfo: docInfo,
      });
    } catch (error: any) {
      setVerificationResult({
        isValid: false,
        message: 'Error al verificar: ' + (error.message || 'Error desconocido'),
      });
    } finally {
      setIsVerifying(false);
    }
  };

  return (
    <div className="w-full space-y-6">
      <div className="p-6 bg-white border border-gray-200 rounded-lg">
        <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
          <Shield className="h-5 w-5" />
          Verificar Documento
        </h3>

        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Archivo a verificar
            </label>
            <div className="border-2 border-dashed border-gray-300 rounded-lg p-4 text-center cursor-pointer hover:border-blue-500 transition-colors">
              <input
                type="file"
                className="hidden"
                id="verify-file-input"
                onChange={handleFileChange}
              />
              <label
                htmlFor="verify-file-input"
                className="cursor-pointer flex flex-col items-center gap-2"
              >
                <Upload className="h-8 w-8 text-gray-400" />
                <span className="text-sm text-gray-600">
                  {file ? file.name : 'Seleccionar archivo'}
                </span>
              </label>
            </div>
            {file && (
              <p className="mt-2 text-xs text-gray-500">
                {(file.size / 1024).toFixed(2)} KB
              </p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Dirección del firmante
            </label>
            <input
              type="text"
              value={signerAddress}
              onChange={(e) => setSignerAddress(e.target.value)}
              placeholder="0x..."
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent font-mono text-sm"
            />
          </div>

          {hash && (
            <div className="p-4 bg-gray-50 rounded-lg">
              <p className="text-sm font-medium text-gray-700 mb-1">Hash calculado:</p>
              <p className="text-xs font-mono text-gray-600 break-all">{hash}</p>
            </div>
          )}

          <button
            onClick={handleVerify}
            disabled={!file || !signerAddress || isVerifying}
            className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            {isVerifying ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                Verificando...
              </>
            ) : (
              <>
                <Shield className="h-4 w-4" />
                Verificar Documento
              </>
            )}
          </button>
        </div>
      </div>

      {verificationResult && (
        <div
          className={`p-6 rounded-lg ${
            verificationResult.isValid
              ? 'bg-green-50 border border-green-200'
              : 'bg-red-50 border border-red-200'
          }`}
        >
          <div className="flex items-center gap-2 mb-4">
            {verificationResult.isValid ? (
              <CheckCircle className="h-6 w-6 text-green-600" />
            ) : (
              <XCircle className="h-6 w-6 text-red-600" />
            )}
            <h4 className="text-lg font-semibold">
              {verificationResult.isValid ? '✅ Válido' : '❌ Inválido'}
            </h4>
          </div>

          <p className="text-sm mb-4">{verificationResult.message}</p>

          {verificationResult.documentInfo && (
            <div className="mt-4 p-4 bg-white rounded-lg">
              <h5 className="font-medium mb-2">Información del documento:</h5>
              <div className="space-y-2 text-sm">
                <div>
                  <span className="font-medium">Firmante:</span>{' '}
                  <span className="font-mono text-xs">
                    {verificationResult.documentInfo.signer}
                  </span>
                </div>
                <div>
                  <span className="font-medium">Timestamp:</span>{' '}
                  <span className="text-xs">
                    {new Date(
                      Number(verificationResult.documentInfo.timestamp) * 1000
                    ).toLocaleString()}
                  </span>
                </div>
                <div>
                  <span className="font-medium">Firma:</span>{' '}
                  <span className="font-mono text-xs break-all">
                    {verificationResult.documentInfo.signature.substring(0, 20)}...
                    {verificationResult.documentInfo.signature.substring(
                      verificationResult.documentInfo.signature.length - 20
                    )}
                  </span>
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

