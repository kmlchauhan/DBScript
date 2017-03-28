using System;

using NUnit.Framework;
using OpenQA.Selenium;

namespace SeleniumParallelTest
{

    [TestFixture]
    public class FirefoxTesting : Hooks
    {

        [Test]
        public void FirefoxGoogleTest()
        {
            Driver.Navigate().GoToUrl("http://www.google.com");
            Driver.FindElement(By.Name("q")).SendKeys("IRIS Software");
            Driver.FindElement(By.Name("btnG")).Click();
            Assert.That(Driver.PageSource.Contains("IRIS Software"), Is.EqualTo(true), "The text IRIS Software doent exist");
        }
    }

    [TestFixture]
    public class ChromeTesting : Hooks
    {

        [Test]
        public void ChromeGoogleTest()
        {
            Driver.Navigate().GoToUrl("http://www.google.com");
            Driver.FindElement(By.Name("q")).SendKeys("IRIS Software");
            Driver.FindElement(By.Name("btnG")).Click();
            Assert.That(Driver.PageSource.Contains("IRIS Software"), Is.EqualTo(true), "The text IRIS Software doent exist");
        }
    }
}
