// Simple light/dark theme toggle persisted in localStorage
(function () {
  const STORAGE_KEY = "smg-theme";

  function getPreferredTheme() {
    const stored = window.localStorage.getItem(STORAGE_KEY);
    if (stored === "light" || stored === "dark") return stored;
    return window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
  }

  function applyTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme);
    const toggles = document.querySelectorAll("[data-theme-toggle]");
    toggles.forEach((btn) => {
      const iconMoon = btn.querySelector("[data-icon='moon']");
      const iconSun = btn.querySelector("[data-icon='sun']");
      if (iconMoon && iconSun) {
        if (theme === "dark") {
          iconMoon.style.display = "none";
          iconSun.style.display = "inline";
        } else {
          iconMoon.style.display = "inline";
          iconSun.style.display = "none";
        }
      }
    });
  }

  function setTheme(theme) {
    window.localStorage.setItem(STORAGE_KEY, theme);
    applyTheme(theme);
  }

  document.addEventListener("DOMContentLoaded", function () {
    const initial = getPreferredTheme();
    applyTheme(initial);

    document.querySelectorAll("[data-theme-toggle]").forEach((btn) => {
      btn.addEventListener("click", function () {
        const current =
          document.documentElement.getAttribute("data-theme") || "light";
        setTheme(current === "dark" ? "light" : "dark");
      });
    });
  });
})();

