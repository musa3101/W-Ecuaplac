/**
 * Dithered Footer Spotlight Interaction (21st Style) - Ecuaplac
 * Activa un haz de luz interactivo siguiendo el cursor del ratón sobre las partículas.
 */
document.addEventListener('DOMContentLoaded', () => {
  const bands = document.querySelectorAll('.df-band');
  bands.forEach((band) => {
    const field = band.querySelector('.df-field');
    if (!field) return;

    let frame = 0;

    band.addEventListener('pointermove', (e) => {
      if (e.pointerType !== 'mouse') return;
      const rect = band.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      cancelAnimationFrame(frame);
      frame = requestAnimationFrame(() => {
        field.style.setProperty('--df-x', `${x}px`);
        field.style.setProperty('--df-y', `${y}px`);
        field.classList.add('df-lit');
      });
    });

    band.addEventListener('pointerleave', () => {
      cancelAnimationFrame(frame);
      field.classList.remove('df-lit');
    });
  });
});
