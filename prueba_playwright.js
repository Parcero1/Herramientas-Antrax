const { chromium } = require('playwright');

(async () => {
  console.log('🔍 Iniciando navegador...');
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  try {
    await page.goto('https://www.bbvanetcash.com/login_default.html', { 
      waitUntil: 'domcontentloaded',
      timeout: 20000 
    });

    console.log('✅ Página cargada');
    console.log('📍 URL:', page.url());
    console.log('📄 Título:', await page.title());

    const datos = await page.evaluate(() => ({
      fnd: typeof fnd !== 'undefined' ? fnd : 'NO_DISPONIBLE',
      tieneProducto: typeof Producto !== 'undefined',
      tienePkms: document.body.innerHTML.includes('pkmslogin.form')
    }));

    console.log('📊 Datos del flujo:', datos);

  } catch (error) {
    console.log('⚠️ Resultado:', error.message);
  } finally {
    await browser.close();
    console.log('🔒 Sesión finalizada');
  }
})();
