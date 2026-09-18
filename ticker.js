(function () {
  function startTicker() {
    const items = document.querySelectorAll('.ticker-item');
    const wrap = document.querySelector('.marquee-wrap');

    if (!items.length || !wrap) {
      // Elements not ready yet, retry in 50ms
      setTimeout(startTicker, 50);
      return;
    }

    console.log("Ticker initialized successfully with", items.length, "items.");

    let currentIndex = 0;
    let timer = null;

    function next() {
      items[currentIndex].classList.remove('active');
      currentIndex = (currentIndex + 1) % items.length;
      items[currentIndex].classList.add('active');
      console.log("Ticker shifted to index:", currentIndex);
    }

    function play() {
      if (!timer) timer = setInterval(next, 3200);
    }

    function pause() {
      clearInterval(timer);
      timer = null;
    }

    wrap.addEventListener('mouseenter', pause);
    wrap.addEventListener('mouseleave', play);

    play();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', startTicker);
  } else {
    startTicker();
  }
})();