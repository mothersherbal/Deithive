const { Builder, By, until } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const assert = require('assert');

// Retrieve configurations from environment variables
const BASE_URL = process.env.BASE_URL || 'http://localhost:5000';
const HEADLESS = process.env.HEADLESS !== 'false'; // Defaults to true (headless mode)

describe('DietHive Frontend Selenium Test Suite', function () {
    // Increase timeout since UI tests can take longer, especially database/network calls
    this.timeout(30000);

    let driver;

    // Helper to dismiss and capture alert text
    async function getAlertTextAndAccept() {
        try {
            await driver.wait(until.alertIsPresent(), 5000);
            const alert = await driver.switchTo().alert();
            const alertText = await alert.getText();
            await alert.accept();
            return alertText;
        } catch (error) {
            throw new Error(`Expected alert to be present, but error occurred: ${error.message}`);
        }
    }

    // Helper to generate a unique email address for registration testing
    function generateUniqueEmail() {
        return `testuser_${Date.now()}@diethive.com`;
    }

    // Generate credentials to share between signup and login tests
    const testUser = {
        name: 'Test Architect',
        age: '28',
        email: generateUniqueEmail(),
        password: 'P@ssword123'
    };

    before(async function () {
        const options = new chrome.Options();
        
        // General options for stability and container/headless compatibility
        if (HEADLESS) {
            options.addArguments('--headless=new');
        }
        options.addArguments('--no-sandbox');
        options.addArguments('--disable-gpu');
        options.addArguments('--disable-dev-shm-usage');
        options.addArguments('--window-size=1280,800');

        driver = await new Builder()
            .forBrowser('chrome')
            .setChromeOptions(options)
            .build();
    });

    after(async function () {
        if (driver) {
            await driver.quit();
        }
    });

    describe('1. Landing Page (index.html)', function () {
        it('should load index.html and display correct title and header elements', async function () {
            await driver.get(`${BASE_URL}/index.html`);

            // Verify title
            const title = await driver.getTitle();
            assert.strictEqual(title, 'Recode Potential | DietHive');

            // Verify top badge is present
            const badge = await driver.findElement(By.className('h-badge'));
            const badgeText = await badge.getText();
            assert.strictEqual(badgeText, 'ELITE BEHAVIORAL PROTOCOL');

            // Verify title text exists
            const header = await driver.findElement(By.className('h-title'));
            const headerText = await header.getText();
            assert.ok(headerText.includes('RECODE'));
        });

        it('should redirect to login.html when clicking on LAUNCH SYNC', async function () {
            await driver.get(`${BASE_URL}/index.html`);

            const launchBtn = await driver.findElement(By.css('a[href="login.html"]'));
            await launchBtn.click();

            // Wait for URL transition
            await driver.wait(until.urlContains('/login'), 5000);

            const currentUrl = await driver.getCurrentUrl();
            assert.ok(currentUrl.endsWith('/login') || currentUrl.endsWith('login.html'), `Expected URL to end with /login but got ${currentUrl}`);
        });
    });

    describe('2. Universal Registration (signup.html)', function () {
        it('should show alert when password and confirm password do not match', async function () {
            await driver.get(`${BASE_URL}/signup.html`);

            // Find inputs
            const nameInput = await driver.findElement(By.id('name'));
            const ageInput = await driver.findElement(By.id('age'));
            const emailInput = await driver.findElement(By.id('email'));
            const passInput = await driver.findElement(By.id('password'));
            const confirmInput = await driver.findElement(By.id('confirm'));
            const checkbox = await driver.findElement(By.css('input[type="checkbox"]'));
            const submitBtn = await driver.findElement(By.css('button[type="submit"]'));

            // Enter valid details but mismatch passwords
            await nameInput.sendKeys(testUser.name);
            await ageInput.sendKeys(testUser.age);
            await emailInput.sendKeys(testUser.email);
            await passInput.sendKeys(testUser.password);
            await confirmInput.sendKeys('DifferentPassword1!');

            // Check terms checkbox
            if (!(await checkbox.isSelected())) {
                await checkbox.click();
            }

            // Click submit
            await submitBtn.click();

            // Check alert message
            const alertText = await getAlertTextAndAccept();
            assert.strictEqual(alertText, 'Passwords do not match!');
        });

        it('should successfully register a new user with correct credentials and show success view', async function () {
            await driver.get(`${BASE_URL}/signup.html`);

            // Re-find inputs since page reloaded/refreshed
            const nameInput = await driver.findElement(By.id('name'));
            const ageInput = await driver.findElement(By.id('age'));
            const emailInput = await driver.findElement(By.id('email'));
            const passInput = await driver.findElement(By.id('password'));
            const confirmInput = await driver.findElement(By.id('confirm'));
            const checkbox = await driver.findElement(By.css('input[type="checkbox"]'));
            const submitBtn = await driver.findElement(By.css('button[type="submit"]'));

            // Enter matching valid details
            await nameInput.sendKeys(testUser.name);
            await ageInput.sendKeys(testUser.age);
            await emailInput.sendKeys(testUser.email);
            await passInput.sendKeys(testUser.password);
            await confirmInput.sendKeys(testUser.password);

            // Toggle terms checkbox
            if (!(await checkbox.isSelected())) {
                await checkbox.click();
            }

            // Submit form
            await submitBtn.click();

            // Wait for successView to display (it changes display style from 'none' to 'block')
            const successView = await driver.findElement(By.id('successView'));
            await driver.wait(until.elementIsVisible(successView), 8000);

            // Verify success header
            const successHeader = await successView.findElement(By.tagName('h2'));
            const successText = await successHeader.getText();
            assert.strictEqual(successText, 'Pathway Confirmed');

            // Verify the proceed to login link points to login.html
            const proceedLink = await successView.findElement(By.css('a[href="login.html"]'));
            assert.ok(proceedLink !== null);
        });
    });

    describe('3. Login Console (login.html)', function () {
        it('should fail authentication with incorrect access key and trigger alert', async function () {
            await driver.get(`${BASE_URL}/login.html`);

            // The login fields are class-based without specific IDs
            const fields = await driver.findElements(By.className('login-field'));
            assert.strictEqual(fields.length, 2, 'Expected exactly two login fields');

            const emailInput = fields[0];
            const passInput = fields[1];
            const submitBtn = await driver.findElement(By.className('btn-auth'));

            // Try to log in with correct email but wrong password
            await emailInput.sendKeys(testUser.email);
            await passInput.sendKeys('WrongPassword1!');
            await submitBtn.click();

            // Check alert message (Flask handles password validation errors with 401 response and frontend alerts)
            const alertText = await getAlertTextAndAccept();
            assert.strictEqual(alertText, 'Incorrect password. Please try again.');
        });

        it('should successfully authenticate with registered credentials and store user variables in localStorage', async function () {
            await driver.get(`${BASE_URL}/login.html`);

            const fields = await driver.findElements(By.className('login-field'));
            const emailInput = fields[0];
            const passInput = fields[1];
            const submitBtn = await driver.findElement(By.className('btn-auth'));

            // Fill correct credentials
            await emailInput.sendKeys(testUser.email);
            await passInput.sendKeys(testUser.password);
            await submitBtn.click();

            // Wait until browser redirects to /home
            await driver.wait(until.urlContains('/home'), 8000);
            
            // Check that we are on home page
            const currentUrl = await driver.getCurrentUrl();
            assert.ok(currentUrl.endsWith('/home') || currentUrl.endsWith('home.html'), `Expected to be redirected to /home but got ${currentUrl}`);

            // Verify localStorage contains the session variables
            const storedEmail = await driver.executeScript("return localStorage.getItem('email');");
            const storedName = await driver.executeScript("return localStorage.getItem('full_name');");
            const storedUserId = await driver.executeScript("return localStorage.getItem('user_id');");

            assert.strictEqual(storedEmail, testUser.email);
            assert.strictEqual(storedName, testUser.name);
            assert.ok(storedUserId !== null && storedUserId !== '');
        });
    });

    describe('4. Session Guard & Home Dashboard (home.html)', function () {
        it('should immediately redirect to login.html if loading home.html without local storage variables', async function () {
            await driver.get(`${BASE_URL}/home.html`);

            // Clear local storage to simulate unauthenticated access
            await driver.executeScript("localStorage.clear();");

            // Refresh the page
            await driver.navigate().refresh();

            // Wait for redirection to /login due to the session guard
            await driver.wait(until.urlContains('/login'), 5000);

            const currentUrl = await driver.getCurrentUrl();
            assert.ok(currentUrl.endsWith('/login') || currentUrl.endsWith('login.html'), `Unauthenticated access should redirect to /login but stayed on ${currentUrl}`);
        });

        it.skip('should load Home dashboard successfully and render daily tip if logged in', async function () {
            // Re-authenticate by signing in again
            await driver.get(`${BASE_URL}/login.html`);

            const fields = await driver.findElements(By.className('login-field'));
            await fields[0].sendKeys(testUser.email);
            await fields[1].sendKeys(testUser.password);
            await driver.findElement(By.className('btn-auth')).click();

            await driver.wait(until.urlContains('/home'), 8000);

            // Verify landing page title
            const title = await driver.getTitle();
            assert.strictEqual(title, 'Home | DietHive');

            // Verify the dynamic Greeting container
            const greeting = await driver.findElement(By.id('dynamicGreeting'));
            const greetingText = await greeting.getText();
            assert.ok(greetingText.length > 0);

            // Verify standard action cards (New Quest, Daily Logs, Analytics) exist
            const actionCards = await driver.findElements(By.className('action-card'));
            assert.ok(actionCards.length >= 3, `Expected at least 3 cards but found ${actionCards.length}`);

            // Verify Daily tip text exists and changes from placeholder
            const tipElement = await driver.findElement(By.id('dailyTipText'));
            
            // Wait for script to update tip text
            await driver.wait(async () => {
                const text = await tipElement.getText();
                return text !== 'Analyzing neural patterns for your daily insight...';
            }, 12000);

            const finalTipText = await tipElement.getText();
            assert.ok(finalTipText.length > 0);
        });
    });

    describe('5. Reset Access Protocol (forgot_password.html)', function () {
        it('should fail with error if attempting forgot-password with unregistered email', async function () {
            await driver.get(`${BASE_URL}/forgot_password.html`);

            const emailInput = await driver.findElement(By.id('reset-email'));
            const submitBtn = await driver.findElement(By.className('btn-main'));

            // Use unregistered email
            await emailInput.sendKeys('unregistered_account_xyz@diethive.com');
            await submitBtn.click();

            // Verify error message box is populated and visible
            const errorMsgBox = await driver.findElement(By.id('general-error'));
            await driver.wait(until.elementIsVisible(errorMsgBox), 6000);

            const errorText = await errorMsgBox.getText();
            assert.strictEqual(errorText, 'Email not registered');
        });
    });
});
