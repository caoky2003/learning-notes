const menu = document.querySelector('.chapter-menu');
const narrow = window.matchMedia('(max-width: 760px)');
const syncMenu = () => { menu.open = !narrow.matches; };
syncMenu();
narrow.addEventListener('change', syncMenu);
const links = [...document.querySelectorAll('.chapter-menu nav a')];
for (const link of links) {
  link.addEventListener('click', () => {
    if (narrow.matches) menu.open = false;
    const target = document.getElementById(link.hash.slice(1));
    if (target) target.focus({ preventScroll: true });
  });
}
const printButton = document.getElementById('print-note');
printButton.hidden = false;
printButton.addEventListener('click', () => window.print());
if ('IntersectionObserver' in window) {
  const observer = new IntersectionObserver(entries => {
    for (const entry of entries) {
      if (!entry.isIntersecting) continue;
      for (const link of links) {
        if (link.hash === `#${entry.target.id}`) link.setAttribute('aria-current', 'location');
        else link.removeAttribute('aria-current');
      }
    }
  }, { rootMargin: '-18% 0px -65% 0px', threshold: 0 });
  document.querySelectorAll('.prose h2').forEach(h => observer.observe(h));
}
