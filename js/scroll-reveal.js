(() => {
  const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const targets = document.querySelectorAll('main > section, main > article, main > .page-layout, .feature-strip__item, .split-section, .icon-card, .news-card, .motto, .stats, .banner, .testimonials, .contact-form-section, .video-full, .page-content > *, .page-sidebar > *');

  targets.forEach((element) => element.classList.add('scroll-reveal'));

  if (reduceMotion || !('IntersectionObserver' in window)) {
    targets.forEach((element) => element.classList.add('is-visible'));
    return;
  }

  const observer = new IntersectionObserver((entries, currentObserver) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add('is-visible');
      currentObserver.unobserve(entry.target);
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });

  targets.forEach((element) => observer.observe(element));
})();
