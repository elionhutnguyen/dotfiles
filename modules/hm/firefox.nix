# modules/hm/firefox.nix
# Vertical Module: Hardened Firefox browser with enterprise policies
{ ... }:
{
  den.default.homeManager =
    { config, lib, ... }:
    let
      cfg = config.my.firefox;
    in
    {
      options.my.firefox = {
        enable = lib.mkEnableOption "hardened Firefox browser with enterprise policies";

        defaultSearchEngine = lib.mkOption {
          type = lib.types.str;
          default = "Brave";
          description = "Default search engine name.";
        };

        dohProviderUrl = lib.mkOption {
          type = lib.types.str;
          default = "https://mozilla.cloudflare-dns.com/dns-query";
          description = "DNS-over-HTTPS resolver endpoint URL.";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.firefox = {
          enable = true;
          policies = {
            HardwareAcceleration = true;
            DisableAppUpdate = true;
            DisableSystemAddonUpdate = true;
            DisableProfileRefresh = true;

            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableFeedbackCommands = true;
            DontCheckDefaultBrowser = true;
            PromptForDownloadLocation = true;
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;

            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            NoDefaultBookmarks = true;
            DisableProfileImport = true;
            DisableSetDesktopBackground = true;

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
              Stories = false;
              SponsoredPocket = false;
              SponsoredStories = false;
              Snippets = false;
              Locked = true;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              FeatureRecommendations = false;
              UrlbarInterventions = false;
              SkipOnboarding = true;
              MoreFromMozilla = false;
              FirefoxLabs = false;
              Locked = true;
            };

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
              Default = cfg.defaultSearchEngine;
              Remove = [
                "Bing"
                "Amazon.com"
                "eBay"
              ];
            };

            HttpsOnlyMode = "force_enabled";
            PostQuantumKeyAgreementEnabled = true;
            DNSOverHTTPS = {
              Enabled = true;
              ProviderURL = cfg.dohProviderUrl;
              Locked = true;
              Fallback = false;
            };

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

            NetworkPrediction = false;
            GenerativeAI = {
              Enabled = false;
              Chatbot = false;
              LinkPreviews = false;
              TabGroups = false;
              Locked = true;
            };

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
    };
}
