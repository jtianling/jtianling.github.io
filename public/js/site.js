// Normalize duplicate content URLs for crawlers and users on the static site.
(function () {
  var pathname = window.location.pathname || "/";
  var normalizedPath = pathname;

  if (normalizedPath.slice(-10) === "index.html") {
    normalizedPath = normalizedPath.slice(0, -10);
  }

  if (normalizedPath === "") {
    normalizedPath = "/";
  }

  if (window.location.search || normalizedPath !== pathname) {
    var target = normalizedPath + window.location.hash;

    if (target !== pathname + window.location.search + window.location.hash) {
      window.location.replace(target);
    }
  }
})();

document.addEventListener("DOMContentLoaded", function () {
  var selectors = [
    "iframe[src*='player.vimeo.com']",
    "iframe[src*='youtube.com']",
    "iframe[src*='youtube-nocookie.com']",
    "iframe[src*='kickstarter.com'][src*='video.html']",
    "object",
    "embed"
  ];

  document.querySelectorAll(selectors.join(",")).forEach(function (element) {
    if (element.closest(".fluid-width-video-wrapper")) {
      return;
    }

    var width = parseFloat(element.getAttribute("width")) || element.clientWidth || 16;
    var height = parseFloat(element.getAttribute("height")) || element.clientHeight || 9;
    var wrapper = document.createElement("div");

    wrapper.className = "fluid-width-video-wrapper";
    wrapper.style.paddingTop = ((height / width) * 100).toFixed(2) + "%";

    element.parentNode.insertBefore(wrapper, element);
    wrapper.appendChild(element);
    element.removeAttribute("width");
    element.removeAttribute("height");
  });
});
