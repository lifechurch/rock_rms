module RockRMS
  module Response
    class SavedPaymentMethod < Base
      MAP = {
        id: 'Id',
        foreign_key: 'ForeignKey',
        gateway_id: 'FinancialGatewayId',
        name: 'Name',
        payment_details: 'FinancialPaymentDetail',
        payment_detail_id: 'FinancialPaymentDetailId',
        reference_number: 'ReferenceNumber',
        is_default: 'IsDefault'
      }.freeze

      def format_single(data)
        response = to_h(MAP, data)
        response[:payment_details] = PaymentDetail.format(response[:payment_details])
        response
      end
    end
  end
end
