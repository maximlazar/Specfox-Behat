<?php

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use MinkFieldRandomizer\Context\FieldRandomizerTrait;
use Behat\Symfony2Extension\Context\KernelAwareContext;
use Smalot\PdfParser\Page;
use Smalot\PdfParser\Parser;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\BrowserStackContext;
use Behat\Mink\Driver\ZombieDriver;
use Behat\Mink\Driver\NodeJS\Server\ZombieServer;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Mink\Exception\ElementNotFoundException;
use Behat\Mink\Exception\ElementTextException;
use Behat\Mink\Exception\ResponseTextException;
use Behat\MinkExtension\Context\RawMinkContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends Behat\MinkExtension\Context\MinkContext implements Context, SnippetAcceptingContext
{
    use FieldRandomizerTrait;
    /**
     * Initializes context.
     *
     * Every scenario gets its own context instance.
     * You can also pass arbitrary arguments to the
     * context constructor through behat.yml.
     */
    public function __construct()
    {
    }

     /**
    * @Then I resize the browser
    */
   public function iResizeTheBrowser()
   {
       $this->getSession()->resizeWindow(1920, 1080, 'current');
   }
   

   /**
    * @When I wait for :text to appear
    * @Then I should see :text appear
    *
    * @param $text
    *
    * @throws \Exception
    */
   public function iWaitForTextToAppear($text)
   {
       $this->spin(function (FeatureContext $context) use ($text) {
           try {
               $context->assertPageContainsText($text);
               return true;
           } catch (ResponseTextException $e) {
               // NOOP
           }
           return false;
       });
   }

   public function spin($lambda)
   {
       while (true) {
           try {
               if ($lambda($this)) {
                   return true;
               }
           } catch (Exception $e) {
               // do nothing
           }
           sleep(1);
       }
   }
   /**
    * Checks, that page contains specified text.
    *
    *@Then /^(?:|I )should see "(?P<text>(?:[^"]|\\")*)" after ajax has finished$/
    */
   public function iShouldSeeAfterAjax($text)
   {
       $time = 10000; // time should be in milliseconds
       $this->getSession()->wait($time, '(0 === jQuery.active)');
       $this->assertPageContainsText($text);
   }

   /**
    *@Given /^I fill hidden field "([^"]*)" with "([^"]*)"$/
    */
   public function iFillHiddenFieldWith($field, $value)
   {
       $this->getSession()->getPage()->find('css',
           'input[name="'.$field.'"]')->setValue($value);
   }

   /**
    * @Then I fill in :arg1 with google location data
    */
   public function iFillInWithGoogleLocationData($arg1)
   {
       $dummyData = '{"locality":"York","administrative_area_level_1":"England","country":"United Kingdom","latitude":53.95996510000001,"longitude":-1.0872979000000669}';
       $this->iFillHiddenFieldWith($arg1, $dummyData);
   }

   /**
    * @when /^(?:|I )confirm the popup$/
    */
   public function confirmPopup()
   {
       $this->getSession()->getDriver()->getWebDriverSession()->accept_alert();
   }
   /**
    * @when /^(?:|I )cancel the popup$/
    */
   public function cancelPopup()
   {
       $this->getSession()->getDriver()->getWebDriverSession()->dismiss_alert();
   }
   /**
    *@When /^(?:|I )should see "([^"]*)" in popup$/
    *
    * @param string $message The message.
    *
    * @return bool
    */
   public function assertPopupMessage($message)
   {
       return $message == $this->getSession()->getDriver()->getWebDriverSession()->getAlert_text();
   }
   /**
    *@When /^(?:|I )fill "([^"]*)" in popup$/
    *
    * @param string $message The message.
    */
   public function setPopupText($message)
   {
       $this->getSession()->getDriver()->getWebDriverSession()->postAlert_text($message);
   }

   /**
     * @When /^I click li option "([^"]*)"$/
     *
     * @param $text
     * @throws \InvalidArgumentException
     */
    public function iClickLiOption($text)
    {
        $session = $this->getSession();
        $element = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '*//*[text()="'. $text .'"]')
        );
 
        if (null === $element) {
            throw new \InvalidArgumentException(sprintf('Cannot find text: "%s"', $text));
        }
 
        $element->click();
    }

    /**
    * Click some text
    *
    * @When /^I click on the text "([^"]*)"$/
    */
    public function iClickOnTheText($text)
    {
        $session = $this->getSession();
        $element = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', '*//*[text()="'. $text .'"]')
        );
        if (null === $element) {
            throw new \InvalidArgumentException(sprintf('Cannot find text: "%s"', $text));
        }
 
        $element->click();
 
    }

    /**
     * Click on the element with the provided xpath query
     *
     * @When /^I click on the element with xpath "([^"]*)"$/
     */
    public function iClickOnTheElementWithXPath($xpath)
    {
        $session = $this->getSession(); // get the mink session
        $element = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('xpath', $xpath)
        ); // runs the actual query and returns the element

        // errors must not pass silently
        if (null === $element) {
            throw new \InvalidArgumentException(sprintf('Could not evaluate XPath: "%s"', $xpath));
        }
        
        // ok, let's click on it
        $element->click();

    }

    /**
     * Click on the element with the provided CSS Selector
     *
     * @When /^I click on the element with css selector "([^"]*)"$/
     */
    public function iClickOnTheElementWithCSSSelector($cssSelector)
    {
        $session = $this->getSession();
        $element = $session->getPage()->find(
            'xpath',
            $session->getSelectorsHandler()->selectorToXpath('css', $cssSelector) // just changed xpath to css
        );
        if (null === $element) {
            throw new \InvalidArgumentException(sprintf('Could not evaluate CSS Selector: "%s"', $cssSelector));
        }

        $element->click();

    }

     /**
     * @When I wait for :text to disappear
     * @Then I should see :text disappear
     * @param $text
     * @throws \Exception
     */
    public function iWaitForTextToDisappear($text)
    {
        $this->spin(function(FeatureContext $context) use ($text) {
            try {
                $context->assertPageContainsText($text);
            }
            catch(ResponseTextException $e) {
                return true;
            }
            return false;
        });
    }

    /**
     * @When /^I wait for (\d+) seconds$/
     */
    public function iWaitForSeconds($seconds)
    {
        $this->getSession()->wait($seconds * 1000);
    }

    /**
     * @When /^I fill selector "([^"]*)" with "([^"]*)"$/
     */
    public function fillSelectorWith($selector, $text)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($text);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random mail$/
     */
    public function fillSelectorWithRandomMail($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomEmail}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random loremipsum$/
     */
    public function fillSelectorWithRandomLoremIpsum($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomLoremIpsum}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random phone$/
     */
    public function fillSelectorWithRandomPhone($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomPhone(9)}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random number$/
     */
    public function fillSelectorWithRandomNumber($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomNumber}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random text$/
     */
    public function fillSelectorWithRandomText($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomText}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random name$/
     */
    public function fillSelectorWithRandomName($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomName}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
     * @When /^I fill selector "([^"]*)" with a random surname$/
     */
    public function fillSelectorWithRandomSurname($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $value = $this->frtFilterValue('{RandomSurname}');

        if($element === null){
            throw new Exception("Element $selector not found");
        }else{
            $element->setValue($value);
        }
    }

    /**
    * Attaches file to field with specified id|name|label|value.
    *
    * @When /^(?:|I )attach the file "(?P<path>[^"]*)" to selector field "([^"]*)"$/
    */
    public function attachFileToField($path, $selector)
    {
        $field = $this->getSession()->getPage()->find('css', $selector);

        if ($this->getMinkParameter('files_path')) {
            $fullPath = rtrim(realpath($this->getMinkParameter('files_path')), DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.$path;
            if (is_file($fullPath)) {
                $path = $fullPath;
            }
        }

        $field->attachFile($path);
    }

    /**
    * @When /^I focus on selector "([^"]*)"$/
    */
    public function focusOnSelector($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $element->focus();
    }

   /**
   * @Given /^I upload the image "([^"]*)"$/
   */
    public function iUploadTheImage($path) {
    // Cannot use the build in MinkExtension function 
    // because the id of the file input field constantly changes and the input field is hidden
    if ($this->getMinkParameter('files_path')) {
      $fullPath = rtrim(realpath($this->getMinkParameter('files_path')), DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.$path;
      
      if (is_file($fullPath)) {
        $fileInput = 'input[type="file"]';
        $field = $this->getSession()->getPage()->find('css', $fileInput);

        if (null === $field) {
           throw new Exception("File input is not found");
        }
        $field->attachFile($fullPath);
      }
    }
    else throw new Exception("File is not found at the given location");      
   }

   /**
   * @Given /^I download a proper PDF file$/
   */
    public function iDownloadAPDFFile()
    {   
        // Get the container    
        $container = $this->kernel->getContainer();
        $session = $container->get('session');
        // Get the session information from Symfony
        $cookieName = $session->getName();
        $sessionId = $session->getId();
        // Find your cookie domain
        $baseUrl = $this->getMinkParameter('base_url');
        $domain = parse_url($baseUrl)['host'];
        $cookieJar = \GuzzleHttp\Cookie\CookieJar::fromArray(array(
        $cookieName => $sessionId,
            ), $domain);
        $guzzle = new \GuzzleHttp\Client(array(
            'timeout' => 10,
            'cookies' => $cookieJar,
        ));
    
        // Provide here the proper download URL
        $url = 'http://specfox.7.ns-qa.xyz/app/projects/0620242e-ed5e-4d3f-a9d5-15909ceac506/export';
        $response = $guzzle->get($url);
        $driver = $this->getSession()->getDriver();
        $contentType = $response->getHeader('Content-Type')[0];
        if ($contentType !== 'application/pdf') {
            throw new \Behat\Mink\Exception\ExpectationException('The content type of the downloaded file is not correct.', $driver);
        }
    }

    /**
     * @Given I have pdf located at :filename
     * @param string $filename
     */
    public function iHavePdfLocatedAt($filename)
    {
        if (!is_readable($filename)) {
            Throw new \InvalidArgumentException(sprintf('The file [%s] is not readable', $filename));
        }
        $this->filename = $filename;
    }
    /**
     * @When I parse the pdf content
     */
    public function iParseThePdfContent()
    {
        $parser = new Parser();
        $pdf    = $parser->parseFile($this->filename);
        $pages  = $pdf->getPages();
        $this->metadata = $pdf->getDetails();
        foreach ($pages as $i => $page) {
            $this->pages[++$i] = $page->getText();
        }
    }
    /**
     * @Then page :pageNum should contain
     * @param int $pageNum
     * @param PyStringNode $string
     */
    public function pageShouldContain($pageNum, PyStringNode $string)
    {
        PHPUnit_Framework_Assert::assertContains((string) $string, $this->pages[$pageNum]);
    }
    /**
     * @Then the the page count should be :pageCount
     * @param int $pageCount
     */
    public function theThePageCountShouldBe($pageCount)
    {
        PHPUnit_Framework_Assert::assertEquals( (int) $pageCount, $this->metadata['Pages']);
    }

     /**
     * @Then /^I move mouse from "([^"]*)" to "([^"]*)"$/
     */
        public function iMoveMouseFrom($selector1, $selector2)
        {
            $session = $this->getSession()->getDriver()->getWebDriverSession();
            $element1 = $this->getSession()->getPage()->find('css', $selector1);
            $element2 = $this->getSession()->getPage()->find('css', $selector2);

            //this requires a sequence of steps as follows:
    //1st find the source and target/destination elements to use as reference to do the drag and drop
            $from = $session->element('xpath',$element1->getXpath());
            $to = $session->element('xpath',$element2->getXpath());
    //now perform drag and drop
            $session->moveto(array('element' => $from->getID())); //move to source location, using reference to source element
            $session->buttondown(""); //click mouse to start drag, defaults to left mouse button
            $session->moveto(array('element' => $to->getID())); //move to target location, using reference to target element
            $session->buttonup(""); //release mouse to complete drag and drop operation
    //it may be worthwhile to encapsulate these steps into a function called draganddrop($src,$target), etc.
        }

      /**
      * @Then /^I drag "([^"]*)" to "([^"]*)"$/
      */
         public function dragfromto($selector1, $selector2)
         {
            $session = $this->getSession()->getDriver()->getWebDriverSession();
            $element1 = $this->getSession()->getPage()->find('css', $selector1);
            $element2 = $this->getSession()->getPage()->find('css', $selector2);

            $element1->focus();
            $element1->dragTo($element2);
         
          }


      /**
      * @Then /^I fill with "([^"]*)" on selector iFrame "([^"]*)" with selector field "([^"]*)"$/
      */
        public function iEnterMyPaymentDetails($value, $selector1, $selector2)
        {

           $iFrame = $this->getSession()->getPage()->find('css', $selector1);
           $iFrameName = $iFrame->getAttribute("name");

          # Switch to the payment iframe
           $this->getSession()->getDriver()->switchToIFrame($iFrameName);

            $field = $this->getSession()->getPage()->find('css', $selector2);
            $field->setValue($value);
     #       $this->getSession()->getDriver()->keyDown($field->getXpath(), '52');
     #       $this->getSession()->getDriver()->keyUp($field->getXpath(), '52');

            # switch back to main content
             $this->getSession()->switchToIFrame();

         }



    /**
    * @When /^I focus on selector "([^"]*)" and type something$/
    */
    public function focusOnSelectorAndTypeSomething($selector)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        $element->focus();
      #  $this->getSession()->getDriver()->keyDown($element->getXpath(), '52');
      #  $this->getSession()->getDriver()->keyUp($element->getXpath(), '52');
      #  $this->getSession()->getDriver()->change($element->getXpath(), '52');
        $key = 'a';
        $modifier = null;

      #  $element->setValue($value);
      #  $script = "jQuery.event.trigger({ type : 'keypress', which : ' . $key . ' });";
      #  $this->getSession()->evaluateScript($script);
    }

    /**
    *@When /^I hover over the element "([^"]*)"$/
    */
    public function iHoverOverTheElement($locator)
    {
        $session = $this->getSession(); // get the mink session
        $element = $session->getPage()->find('css', $locator); // runs the actual query and returns the element

        // errors must not pass silently
        if (null === $element) {
            throw new \InvalidArgumentException(sprintf('Could not evaluate CSS selector: "%s"', $locator));
        }
 
        // ok, let's hover it
        $element->mouseOver();
    }

    /**
    *@Then /^I output the message "([^"]*)"$/
    */
    public function iOutputTheMessage($message)
    {
        var_export($message);
    }

    /**
    *@When /^I fill selector "([^"]*)" with "([^"]*)" and hit down and enter$/
    */
    public function fillSelectorWithHitDownEnter($selector, $text)
    {
        $element = $this->getSession()->getPage()->find('css', $selector);
        if($element === null){
            throw new Exception('Element "'.$selector.'" not found');
        }else{
            $element->setValue($text);
            $element->focus();
 
            $this->getSession()->wait(2 * 1000);
            $this->getSession()->getDriver()->keyPress($element->getXpath(), 40);
 
        }
    }
}
