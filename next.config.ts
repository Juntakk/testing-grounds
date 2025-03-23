import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    domains: ["www.themealdb.com"],
    formats: ["image/avif", "image/webp"],
  },
};

export default nextConfig;
