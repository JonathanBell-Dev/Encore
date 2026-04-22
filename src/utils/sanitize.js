/**
 * sanitize.js — safe DOM helpers to prevent XSS
 *
 * Rule: never set innerHTML with raw user-supplied strings.
 * Always use these helpers or textContent/innerText directly.
 *
 * Import via ES module:
 *   import { escapeHtml, setText, createTextNode } from '../../src/utils/sanitize.js';
 */

/**
 * Escapes HTML special characters in a string.
 * Use when you must build an HTML string (e.g. template literals).
 * Prefer setText() or createTextNode() when possible.
 */
export function escapeHtml(str) {
  if (str === null || str === undefined) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;');
}

/**
 * Safely sets the text content of a DOM element.
 * Equivalent to el.textContent = value but returns the element for chaining.
 */
export function setText(el, value) {
  el.textContent = value === null || value === undefined ? '' : String(value);
  return el;
}

/**
 * Creates a text node — safe alternative to innerHTML for single strings.
 */
export function createTextNode(value) {
  return document.createTextNode(value === null || value === undefined ? '' : String(value));
}

/**
 * Builds a safe element from a tag name, optional attributes, and text content.
 * Attributes are set with setAttribute (no innerHTML). Children can be other
 * Elements or strings (which become text nodes).
 *
 * Example:
 *   const p = el('p', { class: 'msg-text' }, userMessage);
 */
export function el(tag, attrs = {}, ...children) {
  const node = document.createElement(tag);
  for (const [key, val] of Object.entries(attrs)) {
    if (val !== null && val !== undefined) node.setAttribute(key, val);
  }
  for (const child of children) {
    if (child instanceof Node) {
      node.appendChild(child);
    } else {
      node.appendChild(document.createTextNode(String(child ?? '')));
    }
  }
  return node;
}

/**
 * Strips every HTML tag from a string, leaving only plain text.
 * Useful for enforcing plain-text-only fields before they reach the DB.
 */
export function stripTags(str) {
  if (!str) return '';
  const tmp = document.createElement('div');
  tmp.innerHTML = str;
  return tmp.textContent || tmp.innerText || '';
}
