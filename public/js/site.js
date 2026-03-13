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
