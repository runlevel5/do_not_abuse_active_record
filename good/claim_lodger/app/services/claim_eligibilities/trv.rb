module ClaimEligibilities
  class TRV
    attr_reader :errors

    def initialize(client)
      @client = client
      @errors = []
    end

    def eligible?
      @errors = validate_rules

      @errors.blank?
    end

    private

    def rules
      [
        proc { ClaimEligibilityRules::PolicyExpiration.new(@client).validate },
        proc { ClaimEligibilityRules::CoveredTravelDestinations.new(@client).validate },
      ]
    end

    def validate_rules
      rules.map do |rule|
        rule.call
      end.compact
    end

  end
end