'use client';

import React, { useState, useRef } from 'react';
import { Upload, FileText } from 'lucide-react';
import { ethers } from 'ethers';

interface FileUploaderProps {
  onHashCalculated: (hash: string) => void;
}

export default function FileUploader({ onHashCalculated }: FileUploaderProps) {
  const [file, setFile] = useState<File | null>(null);
  const [hash, setHash] = useState<string>('');
  const [isCalculating, setIsCalculating] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const calculateHash = async (file: File) => {
    setIsCalculating(true);
    try {
      const arrayBuffer = await file.arrayBuffer();
      const uint8Array = new Uint8Array(arrayBuffer);
      // Convert Uint8Array to hex string for keccak256
      const hexString = ethers.hexlify(uint8Array);
      const hash = ethers.keccak256(hexString);
      setHash(hash);
      onHashCalculated(hash);
    } catch (error) {
      console.error('Error calculating hash:', error);
      alert('Error al calcular el hash del archivo');
    } finally {
      setIsCalculating(false);
    }
  };

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (selectedFile) {
      setFile(selectedFile);
      await calculateHash(selectedFile);
    }
  };

  const handleDrop = async (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    const droppedFile = e.dataTransfer.files[0];
    if (droppedFile) {
      setFile(droppedFile);
      await calculateHash(droppedFile);
    }
  };

  const handleDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
  };

  return (
    <div className="w-full">
      <div
        className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center cursor-pointer hover:border-blue-500 transition-colors"
        onDrop={handleDrop}
        onDragOver={handleDragOver}
        onClick={() => fileInputRef.current?.click()}
      >
        <input
          ref={fileInputRef}
          type="file"
          className="hidden"
          onChange={handleFileChange}
        />
        <Upload className="mx-auto h-12 w-12 text-gray-400 mb-4" />
        <p className="text-gray-600 mb-2">
          {file ? file.name : 'Haz clic o arrastra un archivo aquí'}
        </p>
        <p className="text-sm text-gray-500">
          Selecciona un archivo para calcular su hash
        </p>
      </div>

      {file && (
        <div className="mt-4 p-4 bg-gray-50 rounded-lg">
          <div className="flex items-center gap-2 mb-2">
            <FileText className="h-5 w-5 text-blue-500" />
            <span className="font-medium">{file.name}</span>
            <span className="text-sm text-gray-500">
              ({(file.size / 1024).toFixed(2)} KB)
            </span>
          </div>
        </div>
      )}

      {isCalculating && (
        <div className="mt-4 text-center text-gray-600">
          Calculando hash...
        </div>
      )}

      {hash && !isCalculating && (
        <div className="mt-4 p-4 bg-blue-50 rounded-lg">
          <p className="text-sm font-medium text-gray-700 mb-1">Hash del documento:</p>
          <p className="text-xs font-mono text-blue-600 break-all">{hash}</p>
        </div>
      )}
    </div>
  );
}

