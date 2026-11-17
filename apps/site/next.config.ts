import type { NextConfig } from "next";

/** A static site: `next build` writes plain HTML to out/, hostable anywhere (Vercel included). */
const nextConfig: NextConfig = {
  output: "export",
  images: { unoptimized: true },
};

export default nextConfig;
