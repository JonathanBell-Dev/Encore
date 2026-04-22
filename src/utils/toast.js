/**
 * toast.js — lightweight toast notification system
 *
 * Usage (import in any page):
 *   import { toast } from '../../src/utils/toast.js';
 *
 *   toast('Profile saved!');                       // success (default)
 *   toast('Something went wrong.', 'error');       // error
 *   toast('Event added to favorites.', 'info');    // info
 *   toast('Are you sure?', 'warning');             // warning
 *
 * Requires css/toast.css to be linked in the page (or use the shared
 * components.css which already includes these rules).
 */

const DURATION = 3500; // ms before auto-dismiss

let container = null;

function getContainer() {
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    document.body.appendChild(container);
  }
  return container;
}

/**
 * Show a toast notification.
 * @param {string} message  - Text to display.
 * @param {'success'|'error'|'info'|'warning'} type
 * @param {number} duration - Auto-dismiss delay in ms (0 = no auto-dismiss).
 */
export function toast(message, type = 'success', duration = DURATION) {
  const c    = getContainer();
  const item = document.createElement('div');
  item.className = `toast toast-${type}`;

  const icon = {
    success: '✓',
    error:   '✕',
    info:    'i',
    warning: '!',
  }[type] || 'i';

  const iconEl = document.createElement('span');
  iconEl.className = 'toast-icon';
  iconEl.textContent = icon;

  const msgEl = document.createElement('span');
  msgEl.className = 'toast-msg';
  msgEl.textContent = message; // textContent — safe, no XSS

  const closeEl = document.createElement('button');
  closeEl.className = 'toast-close';
  closeEl.setAttribute('aria-label', 'Dismiss');
  closeEl.textContent = '×';
  closeEl.addEventListener('click', () => dismiss(item));

  item.appendChild(iconEl);
  item.appendChild(msgEl);
  item.appendChild(closeEl);
  c.appendChild(item);

  // Trigger enter animation
  requestAnimationFrame(() => item.classList.add('toast-visible'));

  if (duration > 0) {
    setTimeout(() => dismiss(item), duration);
  }

  return item;
}

function dismiss(item) {
  item.classList.remove('toast-visible');
  item.classList.add('toast-hiding');
  item.addEventListener('transitionend', () => item.remove(), { once: true });
}
