﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace invoiceDB.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "InvoiceDB Management";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Contact details";

            return View();
        }
    }
}