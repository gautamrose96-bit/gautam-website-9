/* ===== Global site cart (added) =====
   Self-contained cart widget: works on every page that includes this file.
   Persists to localStorage so the cart survives page navigation.
*/
(function () {
  "use strict";

  var STORAGE_KEY = "gautamrose_cart_v1";

  var SITE_CATEGORIES = [
    { label: "Mandala Art", href: "category/mandala-art-hub.html" },
    { label: "Wall Art", href: "category/wall-art-hub.html" },
    { label: "Paintings", href: "category/paintings-hub.html" },
    { label: "Room Decor", href: "category/room-decor-hub.html" },
    { label: "Craft Items", href: "category/craft-items-hub.html" },
    { label: "Healing Quotes Art", href: "category/healing-quotes-hub.html" },
  ];

  function getSiteRoot() {
    var script =
      document.currentScript ||
      Array.prototype.slice
        .call(document.getElementsByTagName("script"))
        .find(function (s) {
          return s.src && s.src.indexOf("site-cart.js") !== -1;
        });
    if (!script) return "";
    return script.src.replace(/assets\/js\/site-cart\.js.*$/, "");
  }

  var ROOT = getSiteRoot();

  function readCart() {
    try {
      var raw = localStorage.getItem(STORAGE_KEY);
      return raw ? JSON.parse(raw) : [];
    } catch (e) {
      return [];
    }
  }

  function writeCart(items) {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    } catch (e) {}
  }

  function money(n) {
    n = Number(n) || 0;
    return "Rs " + n.toLocaleString("en-IN", { maximumFractionDigits: 2 });
  }

  function buildDrawer() {
    if (document.getElementById("site-cart-drawer")) return;

    var overlay = document.createElement("div");
    overlay.id = "site-cart-overlay";
    document.body.appendChild(overlay);

    var toggle = document.createElement("button");
    toggle.id = "site-cart-toggle";
    toggle.setAttribute("aria-label", "Open cart");
    toggle.innerHTML =
      '<i class="fa fa-shopping-cart" aria-hidden="true"></i><span class="site-cart-badge" id="site-cart-badge">0</span>';
    document.body.appendChild(toggle);

    var drawer = document.createElement("div");
    drawer.id = "site-cart-drawer";
    drawer.innerHTML =
      '<div class="site-cart-header">' +
      "<span>Your Cart</span>" +
      '<button id="site-cart-close" aria-label="Close cart">&times;</button>' +
      "</div>" +
      '<div id="site-cart-items"></div>' +
      '<div id="site-cart-footer">' +
      '<div class="site-cart-total"><span>Total</span><span id="site-cart-total-amount">Rs 0</span></div>' +
      '<a href="' + ROOT + 'checkout.html" id="site-cart-checkout">Checkout</a>' +
      "</div>";
    document.body.appendChild(drawer);

    // Floating "Shop Categories" menu
    var catToggle = document.createElement("button");
    catToggle.id = "site-categories-toggle";
    catToggle.setAttribute("aria-label", "Shop categories");
    catToggle.innerHTML = '<i class="fa fa-th-large" aria-hidden="true"></i>';
    document.body.appendChild(catToggle);

    var catMenu = document.createElement("div");
    catMenu.id = "site-categories-menu";
    catMenu.innerHTML =
      '<div class="site-categories-header">Shop by Category</div>' +
      '<ul>' +
      SITE_CATEGORIES.map(function (c) {
        return '<li><a href="' + ROOT + c.href + '">' + c.label + "</a></li>";
      }).join("") +
      '<li><a href="' + ROOT + 'best-sellers.html">Best Sellers</a></li>' +
      "</ul>";
    document.body.appendChild(catMenu);

    catToggle.addEventListener("click", function () {
      catMenu.classList.toggle("open");
    });
    document.addEventListener("click", function (e) {
      if (!catMenu.contains(e.target) && e.target !== catToggle) {
        catMenu.classList.remove("open");
      }
    });

    var toast = document.createElement("div");
    toast.id = "site-cart-toast";
    document.body.appendChild(toast);

    toggle.addEventListener("click", function () {
      drawer.classList.add("open");
      overlay.classList.add("open");
    });
    document.getElementById("site-cart-close").addEventListener("click", closeDrawer);
    overlay.addEventListener("click", closeDrawer);

    function closeDrawer() {
      drawer.classList.remove("open");
      overlay.classList.remove("open");
    }
  }

  var toastTimer = null;
  function showToast(msg) {
    var toast = document.getElementById("site-cart-toast");
    if (!toast) return;
    toast.textContent = msg;
    toast.classList.add("show");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () {
      toast.classList.remove("show");
    }, 1800);
  }

  function render() {
    var items = readCart();
    var badge = document.getElementById("site-cart-badge");
    var list = document.getElementById("site-cart-items");
    var totalEl = document.getElementById("site-cart-total-amount");
    if (!badge || !list || !totalEl) return;

    var count = items.reduce(function (sum, it) {
      return sum + (Number(it.qty) || 1);
    }, 0);
    badge.textContent = count;

    var total = items.reduce(function (sum, it) {
      return sum + (Number(it.price) || 0) * (Number(it.qty) || 1);
    }, 0);
    totalEl.textContent = money(total);

    if (!items.length) {
      list.innerHTML = '<div id="site-cart-empty">Your cart is empty.</div>';
      return;
    }

    list.innerHTML = items
      .map(function (it, idx) {
        var img = it.image
          ? '<img src="' + it.image + '" alt="">'
          : "";
        var size = it.size ? ' &middot; Size: ' + it.size : "";
        return (
          '<div class="site-cart-row" data-idx="' +
          idx +
          '">' +
          img +
          '<div class="site-cart-row-info">' +
          '<div class="name">' +
          (it.name || "Item") +
          "</div>" +
          '<div class="meta">' +
          money(it.price) +
          " x " +
          it.qty +
          size +
          "</div>" +
          "</div>" +
          '<button class="site-cart-remove" title="Remove" data-idx="' +
          idx +
          '"><i class="fa fa-trash" aria-hidden="true"></i></button>' +
          "</div>"
        );
      })
      .join("");

    var removeButtons = list.querySelectorAll(".site-cart-remove");
    for (var i = 0; i < removeButtons.length; i++) {
      removeButtons[i].addEventListener("click", function (e) {
        var idx = Number(e.currentTarget.getAttribute("data-idx"));
        var current = readCart();
        current.splice(idx, 1);
        writeCart(current);
        render();
      });
    }
  }

  function addToCart(item) {
    var items = readCart();
    var existing = items.find(function (it) {
      return it.id === item.id && it.size === item.size;
    });
    if (existing) {
      existing.qty = (Number(existing.qty) || 1) + (Number(item.qty) || 1);
    } else {
      items.push(item);
    }
    writeCart(items);
    render();
    showToast((item.name || "Item") + " added to cart");
  }

  function getSelectedSize(button) {
    var card =
      button.closest(".product, .product-block, .product-box, .caption, li, .item") ||
      button.parentElement;
    if (card) {
      var sel = card.querySelector(".product-size-select");
      if (sel) return sel.value;
    }
    return null;
  }

  function wireAddToCartButtons() {
    var buttons = document.querySelectorAll(
      ".addtocart, .cart_new, [id^='btn-add-cart']"
    );
    buttons.forEach(function (btn) {
      if (btn.getAttribute("data-cart-wired")) return;
      btn.setAttribute("data-cart-wired", "1");

      // Ensure a size selector exists next to this button.
      var card = btn.closest(".product, .product-block, .product-box, .caption, li, .item") || btn.parentElement;
      if (card && !card.querySelector(".product-size-select")) {
        var sizeSelect = document.createElement("select");
        sizeSelect.className = "product-size-select";
        sizeSelect.innerHTML =
          '<option value="Small">Small</option>' +
          '<option value="Medium" selected>Medium</option>' +
          '<option value="Large">Large</option>' +
          '<option value="Extra Large">Extra Large</option>';
        btn.parentNode.insertBefore(sizeSelect, btn);
      }

      btn.addEventListener("click", function (e) {
        e.preventDefault();
        var name =
          btn.getAttribute("itemname") ||
          btn.getAttribute("title") ||
          "Product";
        var price = parseFloat(btn.getAttribute("itemprice")) || 0;
        var id = btn.getAttribute("itemid") || btn.id || name;
        var image = "";
        if (card) {
          var imgEl = card.querySelector("img");
          if (imgEl) image = imgEl.getAttribute("src");
        }
        var size = getSelectedSize(btn) || "Medium";

        addToCart({
          id: id,
          name: name,
          price: price,
          qty: 1,
          size: size,
          image: image,
        });
      });
    });
  }

  function init() {
    buildDrawer();
    render();
    wireAddToCartButtons();
    // Re-scan periodically in case content loads/renders after initial parse
    // (owl carousel, ajax product lists, etc.)
    var scans = 0;
    var interval = setInterval(function () {
      wireAddToCartButtons();
      scans++;
      if (scans > 6) clearInterval(interval);
    }, 800);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
