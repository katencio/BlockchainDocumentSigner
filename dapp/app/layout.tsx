import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { MetaMaskProvider } from "@/contexts/MetaMaskContext";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Document Sign Storage dApp",
  description: "Aplicación descentralizada para firmar y almacenar documentos",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body className={inter.className}>
        <MetaMaskProvider>{children}</MetaMaskProvider>
      </body>
    </html>
  );
}

