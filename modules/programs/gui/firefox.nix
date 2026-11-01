{ ... }:
{
  den.aspects.firefox.homeManager = {
    programs.firefox = {
      enable = true;
      policies = {
        HardwareAcceleration = true;
        # 1. NixOS Compatibility & Update Suppression
        DisableAppUpdate = true;     
        DisableSystemAddonUpdate = true;  
        DisableProfileRefresh = true;

        # 2. Baseline Telemetry & Experiments
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFeedbackCommands = true;
        DontCheckDefaultBrowser = true;
        PromptForDownloadLocation = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        # 3. First-Run & UI De-bloating
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        NoDefaultBookmarks = true;
        DisableProfileImport = true;
        DisableSetDesktopBackground = true;

        # 4. Search Bar & In-Browser Ad Stripping
        SearchSuggestEnabled = false;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = true;
          SponsoredTopSites = false;
          Highlights = true;
          Pocket = false;
          Stories = true;
          SponsoredPocket = false;
          SponsoredStories = true;
          Snippets = false;
          Locked = true;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          FirefoxLabs = true;
          Locked = true;
        };

        # 5. Search Engine Configuration
        SearchEngines = {
          Add = [
            {
              Name = "Brave";
              URLTemplate = "https://search.brave.com/search?q={searchTerms}";
              Method = "GET";
              IconURL = "https://search.brave.com/favicon.ico";
              Alias = "brave";
            }
          ];
          Default = "Brave";
          Remove = [ "Bing" "Amazon.com" "eBay" ];
        };

        # 6. Security, DoH, and Encryption
        HttpsOnlyMode = "force_enabled";
        PostQuantumKeyAgreementEnabled = true;
        DNSOverHTTPS = {
          Enabled = true;
          ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
          Locked = true;
          Fallback = false;
        };

        # 7. Strict Anti-Tracking
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          SuspectedFingerprinting = true;
          Category = "strict";
          BaselineExceptions = true;
          ConvenienceExceptions = true;
        };

        # 8. Network Hygiene & AI Blocking
        NetworkPrediction = false;
        GenerativeAI = {
          Enabled = false;
          Chatbot = true;
          LinkPreviews = true;
          TabGroups = true;
          Locked = true;
        };

        # 9. Disk Space Hygiene (Sanitize on Exit)
        SanitizeOnShutdown = {
          Cache = true;
          FormData = true;
          History = false;
          Cookies = false;
          Sessions = false;
          SiteSettings = false;
          Locked = true;
        };
      };
    };
  };
}
