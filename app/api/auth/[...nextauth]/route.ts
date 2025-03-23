/* eslint-disable @typescript-eslint/no-explicit-any */
import NextAuth from "next-auth";
import AzureADProvider from "next-auth/providers/azure-ad";

const authOptions = {
  providers: [
    AzureADProvider({
      clientId: process.env.AZURE_AD_CLIENT_ID!,
      clientSecret: process.env.AZURE_AD_CLIENT_SECRET!,
      tenantId: process.env.AZURE_AD_TENANT_ID!,
    }),
  ],
  callbacks: {
    async session({ session, token }: { session: any; token: any }) {
      session.user.id = token.sub;
      return session;
    },
  },
};

// Correct API route structure for Next.js App Router
const handler = NextAuth(authOptions);

export const GET = handler;
export const POST = handler;
