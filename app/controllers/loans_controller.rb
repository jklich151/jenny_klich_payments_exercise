class LoansController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: Loan.all
  end

  def show
    loan = Loan.find(params[:id])
    render json: loan.as_json.merge(outstanding_balance: loan.outstanding_balance)
  end

  def create_payment
    loan = Loan.find(params[:loan_id])
    amount = params[:amount].to_f
    payment_date = params[:payment_date]

    if amount <= 0
      render json: { error: 'Payment amount must be greater than 0' }, status: :unprocessable_entity
      return
    end

    if amount > loan.outstanding_balance
      render json: { error: 'Payment amount exceeds outstanding balance' }, status: :unprocessable_entity
      return
    end

    payment = Payment.new(loan: loan, amount: amount, payment_date: payment_date)

    if payment.save
      render json: payment, status: :created
    else
      render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def payments_index
    loan = Loan.find(params[:loan_id])
    render json: loan.payments
  end

  def show_payment
    payment = Payment.find(params[:id])
    render json: payment
  end
end
