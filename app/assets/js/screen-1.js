const CONFIG = window.MENU_CONFIG || {};

const $ = (selector) => document.querySelector(selector);

const elements = {
  title: $("#productTitle"),
  price: $("#productPrice"),
  weight: $("#productWeight"),
  ingredients: $("#productIngredients"),
  ingredientsRow: $("#ingredientsRow"),
  ingredientsLine: $("#ingredientsLine"),
  image: $("#productImage"),
  imageFallback: $("#imageFallback"),
  status: $("#connectionStatus"),
  badge: $("#badgeText")
};

// Lista de produtos.
// Se existir CONFIG.products, usa a lista.
// Se não existir, usa apenas CONFIG.productTitle.
const PRODUCTS = Array.isArray(CONFIG.products) && CONFIG.products.length
  ? CONFIG.products
  : [CONFIG.productTitle];

let currentProductIndex = 0;
let appScriptRows = [];

function getCurrentProductTitle() {
  return PRODUCTS[currentProductIndex];
}

function normalizeText(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/ç/g, "c")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function normalizeForCompare(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/ç/g, "c")
    .replace(/[^a-z0-9]/g, "");
}

function splitTitle(title) {
  const words = String(title || "Produto Especial").trim().split(/\s+/);

  if (words.length <= 1) {
    return [title, ""];
  }

  if (words.length === 2) {
    return [words[0], words[1]];
  }

  const firstLine = words.slice(0, Math.ceil(words.length / 2)).join(" ");
  const secondLine = words.slice(Math.ceil(words.length / 2)).join(" ");

  return [firstLine, secondLine];
}

function formatPrice(value) {
  if (value === undefined || value === null || value === "") {
    return CONFIG.fallbackPrice || "--";
  }

  if (typeof value === "number") {
    return value.toLocaleString("pt-BR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  }

  let text = String(value).trim();

  text = text
    .replace("R$", "")
    .replace(/\s/g, "")
    .trim();

  if (/^\d+(\.\d+)?$/.test(text)) {
    const number = Number(text);

    return number.toLocaleString("pt-BR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  }

  return text;
}

function pickField(item, fieldNames) {
  if (!item || typeof item !== "object") return "";

  const keys = Object.keys(item);

  const normalizedMap = new Map(
    keys.map((key) => [normalizeForCompare(key), key])
  );

  for (const name of fieldNames) {
    const key = normalizedMap.get(normalizeForCompare(name));

    if (
      key &&
      item[key] !== undefined &&
      item[key] !== null &&
      item[key] !== ""
    ) {
      return item[key];
    }
  }

  return "";
}

function extractRows(payload) {
  if (Array.isArray(payload)) return payload;

  if (payload && Array.isArray(payload.data)) return payload.data;
  if (payload && Array.isArray(payload.items)) return payload.items;
  if (payload && Array.isArray(payload.produtos)) return payload.produtos;
  if (payload && Array.isArray(payload.products)) return payload.products;
  if (payload && Array.isArray(payload.result)) return payload.result;

  if (payload && typeof payload === "object") {
    const firstArray = Object.values(payload).find(Array.isArray);
    if (firstArray) return firstArray;
  }

  return [];
}

function findProduct(rows) {
  const target = normalizeForCompare(getCurrentProductTitle());

  if (!target) return null;

  return rows.find((item) => {
    const name = pickField(item, [
      "produto",
      "nome",
      "name",
      "titulo",
      "título",
      "title",
      "item"
    ]);

    return normalizeForCompare(name) === target;
  });
}

function getProductData(item) {
  const title = pickField(item, [
    "produto",
    "nome",
    "name",
    "titulo",
    "título",
    "title",
    "item"
  ]) || getCurrentProductTitle();

  const price = pickField(item, [
    "preco",
    "preço",
    "valor",
    "price",
    "preco_venda",
    "preço venda",
    "varejo"
  ]) || CONFIG.fallbackPrice;

  const weight = pickField(item, [
    "gramatura",
    "peso",
    "weight",
    "quantidade",
    "porcao",
    "porção"
  ]) || CONFIG.fallbackWeight || "";

  const ingredients = pickField(item, [
    "ingredientes",
    "ingredients",
    "composicao",
    "composição"
  ]) || CONFIG.fallbackIngredients || "";

  return {
    title,
    price: formatPrice(price),
    weight,
    ingredients
  };
}

function renderProduct(data) {
  const [line1, line2] = splitTitle(data.title);
  const titleLength = String(data.title || "").length;
  const titleWordCount = String(data.title || "").trim().split(/\s+/).filter(Boolean).length;

  elements.title.classList.toggle("title-long", titleLength > 18 || titleWordCount > 3);
  elements.title.classList.toggle("title-extra-long", titleLength > 26 || titleWordCount > 4);

  elements.title.innerHTML = `
    <span>${line1}</span>
    <span>${line2 || "&nbsp;"}</span>
  `;

  elements.price.textContent = data.price || CONFIG.fallbackPrice || "--";
  elements.weight.textContent = data.weight || CONFIG.fallbackWeight || "";

  const ingredients = String(data.ingredients || CONFIG.fallbackIngredients || "").trim();
  elements.ingredients.textContent = ingredients;
  elements.ingredientsRow.hidden = !ingredients;
  elements.ingredientsLine.hidden = !ingredients;

  elements.badge.textContent = CONFIG.badgeText || "Destaque";

  const imageSlug = normalizeText(data.title || getCurrentProductTitle());
  const imagePath = `${CONFIG.productImageFolder || "assets/products"}/${imageSlug}.png`;

  elements.image.src = imagePath;
  elements.image.alt = data.title;

  elements.image.onload = () => {
    elements.image.style.display = "block";
    elements.imageFallback.style.display = "none";
  };

  elements.image.onerror = () => {
    elements.image.style.display = "none";
    elements.imageFallback.style.display = "grid";
  };
}

function renderFallback(reason = "") {
  renderProduct({
    title: getCurrentProductTitle(),
    price: CONFIG.fallbackPrice || "--",
    weight: CONFIG.fallbackWeight || "",
    ingredients: CONFIG.fallbackIngredients || ""
  });

  elements.status.textContent = reason || "Usando dados locais.";
}

function renderCurrentProduct() {
  const productTitle = getCurrentProductTitle();
  const item = findProduct(appScriptRows);

  if (!item) {
    renderProduct({
      title: productTitle,
      price: CONFIG.fallbackPrice || "--",
      weight: CONFIG.fallbackWeight || "",
      ingredients: CONFIG.fallbackIngredients || ""
    });

    elements.status.textContent = `Produto não encontrado no App Script: ${productTitle}`;
    return;
  }

  renderProduct(getProductData(item));

  elements.status.textContent = `Produto atual: ${productTitle}`;
}

function nextProduct() {
  if (!PRODUCTS.length) return;

  currentProductIndex = (currentProductIndex + 1) % PRODUCTS.length;
  renderCurrentProduct();
}

async function loadProductsFromAppScript() {
  try {
    elements.status.textContent = "Atualizando dados...";

    const response = await fetch(CONFIG.appScriptUrl, {
      method: "GET",
      cache: "no-store"
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const payload = await response.json();

    appScriptRows = extractRows(payload);

    if (!appScriptRows.length) {
      renderFallback("App Script retornou vazio ou em formato inválido.");
      return;
    }

    renderCurrentProduct();

    elements.status.textContent = `Dados atualizados às ${new Date().toLocaleTimeString("pt-BR", {
      hour: "2-digit",
      minute: "2-digit"
    })}.`;
  } catch (error) {
    console.error("Erro ao carregar App Script:", error);

    renderFallback("Erro ao carregar App Script. Usando fallback.");
  }
}

// Primeira renderização imediata para não deixar tela vazia.
renderFallback("Carregando dados...");

// Busca os dados no App Script.
loadProductsFromAppScript();

// Alterna os produtos.
setInterval(() => {
  nextProduct();
}, (CONFIG.rotateEverySeconds || 20) * 1000);

// Atualiza os dados do App Script.
setInterval(() => {
  loadProductsFromAppScript();
}, (CONFIG.refreshEverySeconds || 300) * 1000);