document.addEventListener("DOMContentLoaded", () => {
  // Active nav link
  const path = window.location.pathname;
  document.querySelectorAll("nav a").forEach(a => {
    if (a.getAttribute("href") === path) a.classList.add("active");
  });

  // Animate elements on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.style.opacity = "1";
        e.target.style.transform = "translateY(0)";
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll(".card, .thread-viz, .race-demo").forEach(el => {
    el.style.opacity = "0";
    el.style.transform = "translateY(20px)";
    el.style.transition = "opacity 0.5s, transform 0.5s";
    observer.observe(el);
  });
});
