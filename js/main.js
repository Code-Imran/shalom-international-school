/* ============================================================
   Mobile nav toggle
   ============================================================ */
const navToggle = document.getElementById('navToggle');
const navMenu = document.getElementById('navMenu');
if (navToggle && navMenu) {
  navToggle.addEventListener('click', () => {
    const open = navMenu.classList.toggle('is-open');
    navToggle.setAttribute('aria-expanded', open);
  });
}

/* ============================================================
   Language dropdown + Google Translate
   ============================================================ */
const langBtn = document.getElementById('langBtn');
const langMenu = document.getElementById('langMenu');
if (langBtn && langMenu) {
  langBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const open = langMenu.classList.toggle('is-open');
    langBtn.setAttribute('aria-expanded', open);
  });
  document.addEventListener('click', () => {
    langMenu.classList.remove('is-open');
    langBtn.setAttribute('aria-expanded', 'false');
  });
}

// Wire up the language links to Google Translate
function changeLanguage(langCode) {
  const select = document.querySelector('#google_translate_element select.goog-te-combo');
  if (select) {
    select.value = langCode;
    select.dispatchEvent(new Event('change'));
  } else {
    document.cookie = `googtrans=/en/${langCode}; path=/`;
    document.cookie = `googtrans=/en/${langCode}; domain=.${location.hostname}; path=/`;
    location.reload();
  }
}

document.querySelectorAll('.lang-select__menu a[data-lang]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    changeLanguage(link.getAttribute('data-lang'));
    if (langMenu) langMenu.classList.remove('is-open');
    if (langBtn) langBtn.setAttribute('aria-expanded', 'false');
  });
});

window.googleTranslateElementInit = function () {
  new google.translate.TranslateElement(
    {
      pageLanguage: 'en',
      includedLanguages: 'en,mr,hi',
      layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
      autoDisplay: false,
    },
    'google_translate_element'
  );
};
/* ============================================================
   Page Quotes
   ============================================================ */
const pageQuotes = {
  'index.html': '"Education is the most powerful weapon which you can use to change the world." — Nelson Mandela',
  'about_us.html': '"The beautiful thing about learning is that nobody can take it away from you." — B.B. King',
  'vision-and-mission.html': '"The function of education is to teach one to think intensively and to think critically." — Martin Luther King Jr.',
  'facilities.html': '"The mind is not a vessel to be filled, but a fire to be kindled." — Plutarch',
  'management.html': '"A child educated only at school is an uneducated child." — George Santayana',
  'news.html': '"An investment in knowledge pays the best interest." — Benjamin Franklin',
  'things-to-bring.html': '"Education is not preparation for life; education is life itself." — John Dewey',
  'parent-declaration.html': '"Children must be taught how to think, not what to think." — Margaret Mead',
  'contact-us.html': '"The roots of education are bitter, but the fruit is sweet." — Aristotle'
};
const pageName = window.location.pathname.split('/').pop() || 'index.html';
const quote = document.querySelector('.quote');
if (quote && pageQuotes[pageName]) quote.textContent = pageQuotes[pageName];

/* ============================================================
   Hero slider
   ============================================================ */
const slides = document.querySelectorAll('.hero-slide');
const dotsWrap = document.getElementById('heroDots');
let currentSlide = 0;
let slideTimer;

if (slides.length && dotsWrap) {
  dotsWrap.innerHTML = '';
  slides.forEach((_, i) => {
    const dot = document.createElement('button');
    dot.className = 'hero-slider__dot' + (i === 0 ? ' is-active' : '');
    dot.setAttribute('aria-label', `Go to slide ${i + 1}`);
    dot.addEventListener('click', () => {
      goToSlide(i);
      resetSlideTimer();
    });
    dotsWrap.appendChild(dot);
  });

  function goToSlide(i) {
    slides[currentSlide].classList.remove('is-active');
    dotsWrap.children[currentSlide].classList.remove('is-active');
    currentSlide = i;
    slides[currentSlide].classList.add('is-active');
    dotsWrap.children[currentSlide].classList.add('is-active');
  }

  function nextSlide() {
    goToSlide((currentSlide + 1) % slides.length);
  }

  function resetSlideTimer() {
    clearInterval(slideTimer);
    slideTimer = setInterval(nextSlide, 5500);
  }

  resetSlideTimer();
}

/* ============================================================
   Unified Web3Forms Submission & Validation
   ============================================================ */
const contactForm = document.getElementById('contactForm');

if (contactForm) {
  contactForm.addEventListener('submit', async function(e) {
    e.preventDefault();
    const statusEl = document.getElementById('cf-status');
    const submitBtn = document.getElementById('cf-submit');

    statusEl.className = 'form-status';
    statusEl.textContent = 'Sending message...';
    submitBtn.disabled = true;

    const formData = new FormData(contactForm);
    const jsonObject = Object.fromEntries(formData);

    try {
      const response = await fetch('https://api.web3forms.com/submit', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify(jsonObject)
      });

      const jsonResponse = await response.json();

      if (response.status === 200) {
        statusEl.className = 'form-status form-status--success';
        statusEl.textContent = 'Thank you! Your message has been sent successfully.';
        contactForm.reset();
      } else {
        statusEl.className = 'form-status form-status--error';
        statusEl.textContent = jsonResponse.message || 'Something went wrong. Please try again.';
      }
    } catch (error) {
      statusEl.className = 'form-status form-status--error';
      statusEl.textContent = 'Network error. Please check your connection and try again.';
    } finally {
      submitBtn.disabled = false;
    }
  });
}
// Auto-sync homepage news with news.html
document.addEventListener('DOMContentLoaded', function () {
  var grid = document.getElementById('newsGrid');
  if (!grid) return;

  fetch('news.html?t=' + Date.now(), { cache: 'no-store' })
    .then(function (res) { return res.text(); })
    .then(function (data) {
      var parser = new DOMParser();
      var doc = parser.parseFromString(data, 'text/html');
      var articles = doc.querySelectorAll('#news-list article');

      if (articles.length > 0) {
        grid.innerHTML = '';
        articles.forEach(function (article) {
          var dateEl = article.querySelector('span');
          var titleEl = article.querySelector('h1, h2, h3');
          var textEl = article.querySelector('p');

          var card = document.createElement('article');
          card.className = 'news-card';
          card.innerHTML =
            '<span class="news-card__date">' + (dateEl ? dateEl.textContent.trim() : '') + '</span>' +
            '<h3>' + (titleEl ? titleEl.innerHTML : '') + '</h3>' +
            '<p>' + (textEl ? textEl.innerHTML : '') + '</p>';
          grid.appendChild(card);
        });
      }
    })
    .catch(function (err) {
      console.warn('Fallback to static cards:', err);
    });
});
document.querySelectorAll('.marquee').forEach((marquee) => {
  const content = marquee.querySelector('.marquee-content');
  if (!content || content.parentElement.classList.contains('marquee-viewport')) return;
  const viewport = document.createElement('span');
  viewport.className = 'marquee-viewport';
  content.parentNode.insertBefore(viewport, content);
  viewport.appendChild(content);
});
