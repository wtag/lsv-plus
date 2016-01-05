module LSVplus
  module FormattingHelper
    DATE_FORMAT = '%Y%m%d'

    def self.date(date)
      date.strftime DATE_FORMAT
    end

    def self.index(index)
      format '%07d', index
    end

    def self.amount(amount)
      format('%012.2f', amount).sub('.', ',')
    end

    def self.multiline(lines)
      lines_string = StringIO.new
      4.times do |index|
        lines_string.write format('%-35s', lines[index])
      end
      lines_string.rewind
      lines_string.read
    end

    def self.account(account)
      format '%-34s', account
    end

    def self.clearing_number(number)
      format '%-5s', number
    end
  end
end
