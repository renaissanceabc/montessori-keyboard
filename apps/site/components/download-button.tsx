import { ExternalLink } from "@/components/external-link";

import { site } from "../site.config";

/** The App Store pill: "Coming soon" until the app is published (`appStoreLive` in site.config.ts). */
export function DownloadButton() {
  if (!site.appStoreLive) {
    return (
      <span className="download" aria-disabled="true">
        Coming soon to the App Store
      </span>
    );
  }

  return (
    <ExternalLink href={site.appStoreUrl} className="download" arrow={false}>
      Get it on the App Store
    </ExternalLink>
  );
}
