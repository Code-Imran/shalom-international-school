(function () {
  function injectFooter() {
    const footerContainer = document.getElementById('site-footer-container');
    if (!footerContainer) return;

    const footerHTML = `
<footer class="site-footer" id="contact" style="background-color: #800000; color: #ffffff;">
  <!-- Contacts Bar: Pure White Background, Black Text -->
  <div class="footer-contacts" style="background-color: #ffffff; color: #000000; display: flex; justify-content: space-around; align-items: center; padding: 1.25rem 1rem; flex-wrap: wrap; gap: 1.5rem; border-bottom: 1px solid #e0dcd7;">
    <div style="text-align: center;">
      <h3 style="color: #000000; margin: 0 0 0.25rem 0; font-size: 1.1rem; font-weight: 700;">Reception</h3>
      <p style="color: #111111; margin: 0; font-size: 1rem; font-weight: 600;">+91 75887-20154</p>
    </div>
    <div style="text-align: center;">
      <h3 style="color: #000000; margin: 0 0 0.25rem 0; font-size: 1.1rem; font-weight: 700;">Student Emergency</h3>
      <p style="color: #111111; margin: 0; font-size: 1rem; font-weight: 600;">+91 98224-40656</p>
    </div>
    <div style="text-align: center;">
      <h3 style="color: #000000; margin: 0 0 0.25rem 0; font-size: 1.1rem; font-weight: 700;">Admissions</h3>
      <p style="color: #111111; margin: 0; font-size: 1rem; font-weight: 600;">+91 98506-72949</p>
    </div>
  </div>

  <!-- Main Footer Body -->
  <div class="footer-main" style="display: flex; flex-wrap: wrap; gap: 2rem; align-items: flex-start; padding: 2.5rem 1.5rem 1.5rem; max-width: 1200px; margin: 0 auto;">
    <div class="footer-main__address" style="flex: 1; min-width: 280px; color: #ffffff;">
      <h2 style="color: #ffffff; margin-top: 0; margin-bottom: 1rem; font-size: 1.5rem; font-weight: 700;">Shalom International School, Panchgani</h2>
      
      <h3 style="color: #f5a623; margin: 1.25rem 0 0.25rem 0; font-size: 1rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Walk in address:</h3>
      <p style="color: #ffffff; margin: 0 0 0.5rem 0; font-size: 0.95rem; line-height: 1.5;">Shalom International School, Opp. Ambedkar Garden, Chesson Road, Panchgani, 412805 Maharashtra.</p>
      
      <h3 style="color: #f5a623; margin: 1.25rem 0 0.25rem 0; font-size: 1rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Phone numbers:</h3>
      <p style="color: #ffffff; margin: 0 0 0.5rem 0; font-size: 0.95rem; line-height: 1.5;">☎ 98506-72949, 982244-0656</p>
      
      <h3 style="color: #f5a623; margin: 1.25rem 0 0.25rem 0; font-size: 1rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;">Email:</h3>
      <p style="color: #ffffff; margin: 0 0 0.5rem 0; font-size: 0.95rem; line-height: 1.5;">✉ <a href="mailto:info@shalominternationalschool.com" style="color: #ffffff; text-decoration: none;">info@shalominternationalschool.com</a></p>
    </div>
    
    <div class="footer-main__map" style="flex: 1; min-width: 280px;">
      <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3783.257!2d73.8012!3d17.9221!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMTfCsDU1JzE5LjUiTiA3M8KwNDgnMDQuMyJF!5e0!3m2!1sen!2sin!4v1620000000000" title="Shalom International School location map" allowfullscreen loading="lazy" style="border: 0; width: 100%; height: 260px; border-radius: 8px;"></iframe>
    </div>
  </div>

  <!-- Bottom Navigation Menu -->
  <div class="footer-bottom-menu" style="background-color: #fdfaf6; padding: 0.75rem 0; margin-top: 1.5rem;">
    <ul style="display: flex; flex-wrap: wrap; justify-content: center; gap: 1.5rem; list-style: none; margin: 0; padding: 0;">
      <li><a href="index.html" style="color: #111111; font-weight: 700; font-size: 0.92rem; text-decoration: none;">Home</a></li>
      <li><a href="about_us.html" style="color: #111111; font-weight: 700; font-size: 0.92rem; text-decoration: none;">About us</a></li>
      <li><a href="facilities.html" style="color: #111111; font-weight: 700; font-size: 0.92rem; text-decoration: none;">Facilities</a></li>
      <li><a href="news.html" style="color: #111111; font-weight: 700; font-size: 0.92rem; text-decoration: none;">News &amp; Events</a></li>
      <li><a href="contact-us.html" style="color: #111111; font-weight: 700; font-size: 0.92rem; text-decoration: none;">Contact us</a></li>
    </ul>
  </div>

  <!-- Copyright & Web Architect Link -->
  <div class="footer-bottom-copy" style="text-align: center; padding: 0.85rem 1rem; font-size: 0.85rem; color: #ffffff; background-color: #800000; border-top: 1px solid rgba(255, 255, 255, 0.1);">
    <p style="margin: 0;">&copy; 2026 Shalom International School | Web Architect: <a href="https://www.linkedin.com/in/imran-shaikh-webdeveloper/" target="_blank" rel="noopener noreferrer" style="color: #f5a623; font-weight: 700; text-decoration: underline;">Imran Shaikh</a></p>
  </div>
</footer>
`;

    footerContainer.outerHTML = footerHTML;
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', injectFooter);
  } else {
    injectFooter();
  }
})();