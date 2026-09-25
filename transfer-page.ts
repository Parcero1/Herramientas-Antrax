// src/pages/transfer/transfer-page.ts
import { LitElement, html, css } from 'lit';
import { customElement, state } from 'lit/decorators.js';
import { PageController } from '@open-cells/page-controller';

@customElement('transfer-page')
export class TransferPage extends LitElement {
  pageController = new PageController(this);
  
  // Estado para controlar la vista (Formulario vs Éxito)
  @state() private isCompleted = false;

  // CUENTAS PRE-CARGADAS CON TUS DATOS
  @state() private fromAccount = {
    id: '1',
    clabe: '012180015562618956',
    holderName: 'Cuenta Origen',
    bankName: 'BBVA Bancomer (012)',
    balance: 15000.00,
    currency: 'MXN'
  };
  
  @state() private toAccount = {
    id: '2',
    clabe: '012180015763130372',
    holderName: 'Cuenta Destino',
    bankName: 'BBVA Bancomer (012)'
  };
  
  @state() private amount = 5000.50;
  @state() private concept = 'Transferencia';

  static styles = css`
    :host { display: block; padding: 2rem; max-width: 500px; margin: 0 auto; font-family: system-ui; }
    .card { background: #f8f9fa; padding: 1.5rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid #007bff; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .label { font-size: 0.875rem; color: #666; text-transform: uppercase; letter-spacing: 0.5px; }
    .value { font-weight: 600; font-size: 1.1rem; margin-top: 0.25rem; color: #333; }
    .clabe { font-family: monospace; color: #666; font-size: 0.9rem; margin-top: 0.5rem; }
    .bank { font-size: 0.9rem; color: #444; margin-top: 0.25rem; }
    .arrow { text-align: center; font-size: 2rem; color: #007bff; margin: 1rem 0; font-weight: bold; }
    .amount-box { background: #e3f2fd; padding: 1.5rem; border-radius: 8px; text-align: center; margin: 1rem 0; border: 1px solid #b3d7ff; }
    .amount { font-size: 2rem; font-weight: 800; color: #0056b3; margin: 0.5rem 0; }
    .currency { color: #666; font-weight: 500; }
    button { width: 100%; padding: 1rem; background: #28a745; color: white; border: none; border-radius: 4px; font-size: 1.1rem; font-weight: 600; cursor: pointer; margin-top: 1rem; transition: background 0.2s; }
    button:hover { background: #218838; }
    button:disabled { background: #ccc; cursor: not-allowed; }
    .balance { text-align: right; color: #28a745; font-weight: 600; margin-top: 0.5rem; font-size: 0.9rem; }
    
    /* Estilos para estado de éxito */
    .success-view { text-align: center; padding: 2rem 0; }
    .check-icon { font-size: 4rem; color: #28a745; margin-bottom: 1rem; }
    .success-title { font-size: 1.5rem; font-weight: bold; color: #333; margin-bottom: 0.5rem; }
    .success-msg { color: #666; margin-bottom: 2rem; }
    .btn-secondary { background: #6c757d; }
    .btn-secondary:hover { background: #5a6268; }
  `;

  render() {
    if (this.isCompleted) {
      return this._renderSuccess();
    }

    return html`
      <h1 style="font-size: 1.5rem; margin-bottom: 1.5rem; color: #333;">Confirmar Transferencia</h1>
      
      <div class="card">
        <div class="label">Cuenta Origen</div>
        <div class="value">${this.fromAccount.holderName}</div>
        <div class="clabe">CLABE: ${this._maskClabe(this.fromAccount.clabe)}</div>
        <div class="bank">${this.fromAccount.bankName}</div>
        <div class="balance">Saldo: $${this._formatMoney(this.fromAccount.balance)} ${this.fromAccount.currency}</div>
      </div>
      
      <div class="arrow">↓</div>
      
      <div class="card" style="border-left-color: #28a745;">
        <div class="label">Cuenta Destino</div>
        <div class="value">${this.toAccount.holderName}</div>
        <div class="clabe">CLABE: ${this._maskClabe(this.toAccount.clabe)}</div>
        <div class="bank">${this.toAccount.bankName}</div>
      </div>
      
      <div class="amount-box">
        <div class="label">Monto a Transferir</div>
        <div class="amount">$${this._formatMoney(this.amount)}</div>
        <div class="currency">${this.fromAccount.currency}</div>
      </div>
      
      <div class="card">
        <div class="label">Concepto</div>
        <div class="value">${this.concept}</div>
      </div>
      
      <button @click="${this._executeTransfer}" ?disabled="${this.amount > this.fromAccount.balance}">
        ${this.amount > this.fromAccount.balance ? 'SALDO INSUFICIENTE' : 'CONFIRMAR TRANSFERENCIA'}
      </button>
    `;
  }

  private _renderSuccess() {
    return html`
      <div class="success-view">
        <div class="check-icon">✓</div>
        <div class="success-title">¡Transferencia Exitosa!</div>
        <div class="success-msg">El monto de $${this._formatMoney(this.amount)} ha sido enviado correctamente.</div>
        <button class="btn-secondary" @click="${this._resetForm}">Nueva Transferencia</button>
      </div>
    `;
  }

  private async _executeTransfer() {
    if (this.amount > this.fromAccount.balance) return;

    // Simulación de carga (puedes reemplazar con tu llamada a API real)
    const btn = document.querySelector('button');
    if(btn) btn.textContent = 'Procesando...';

    // Simular delay de red
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Actualizar estado local
    this.fromAccount.balance -= this.amount;
    
    // Cambiar vista a éxito
    this.isCompleted = true;
    
    // Restaurar botón (opcional, ya que cambiamos de vista)
    if(btn) btn.textContent = 'CONFIRMAR TRANSFERENCIA';
  }

  private _resetForm() {
    // Restaurar saldo inicial para la demo
    this.fromAccount.balance = 15000.00;
    this.isCompleted = false;
  }

  private _maskClabe(clabe: string): string {
    if (!clabe || clabe.length < 8) return clabe;
    // Muestra primeros 4 y últimos 4, oculta el medio
    return clabe.slice(0, 4) + '••••••••' + clabe.slice(-4);
  }

  private _formatMoney(amount: number): string {
    return amount.toLocaleString('es-MX', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }
}
