const puppeteer = require('puppeteer-core');

(async () => {
  const browser = await puppeteer.launch({
    executablePath: '/system/bin/chromium',
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  const page = await browser.newPage();

  await page.goto('https://www.bbvanetcash.com/login_default.html', { waitUntil: 'networkidle2' });

  console.log('URL:', page.url());
  console.log('Título:', await page.title());

  const datos = await page.evaluate(() => ({
    fnd: typeof fnd !== 'undefined' ? fnd : 'NO_DISPONIBLE',
    tieneProducto: typeof Producto !== 'undefined'
  }));

  console.log('Datos:', datos);

  await page.waitForTimeout(3000);
  await browser.close();
})();
