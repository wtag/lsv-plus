# LSV+ [![Circle CI](https://circleci.com/gh/wtag/lsv-plus.svg?style=svg)](https://circleci.com/gh/wtag/lsv-plus) [![Code Climate](https://codeclimate.com/github/wtag/lsv-plus/badges/gpa.svg)](https://codeclimate.com/github/wtag/lsv-plus) [![Coverage Status](https://coveralls.io/repos/wtag/lsv-plus/badge.svg?branch=master&service=github)](https://coveralls.io/github/wtag/lsv-plus?branch=master)

Create LSV+ files with ease.

## Setup

Add the gem to your project:

```ruby
gem 'lsv-plus'
```

Run bundle to install:

```shell
$ bundle install
```

## Usage

To create a new LSV+ file, follow the steps below.

```ruby
# instantiate a new LSV+ file
file = LSVplus::File.new(
  creator_identification: 'WTAGI',
  currency: 'CHF',
  processing_type: 'P',
  creation_date: Date.today,
  lsv_identification: 'WT001',
)

# add some records to the file
record1 = LSVplus::Record.new(
  processing_date: Date.today + 1,
  creditor_bank_clearing_number: 1337,
  amount: BigDecimal.new('1337.42'),
  debitor_bank_clearing_number: 42,
  creditor_iban: 'CH9300762011623852957',
  creditor_address: ['Fancy AG', 'Funnystreet 42'],
  debitor_account: '123.456-78XY',
  debitor_address: ['Debit AG', 'Other Street 1337', 'Somewhere City'],
  message: ['Invoice 133 via BDD'],
  reference_type: 'A',
  reference: '200002000000004443332000061',
  esr_member_id: '133742',
)
file.add_record record1

record2 = LSVplus::Record.new(
  processing_date: Date.today + 1,
  creditor_bank_clearing_number: 1337,
  amount: BigDecimal.new('42.10'),
  debitor_bank_clearing_number: 1337,
  creditor_iban: 'CH9300762011623852957',
  creditor_address: ['Fancy AG', 'Funnystreet 42'],
  debitor_account: '455.24401-AB',
  debitor_address: ['Customer 77', 'Bubu Av', 'New Lala City'],
  message: ['Invoice 42 via BDD'],
  reference_type: 'B',
  reference: '030000SWAGFEEFORYOLO',
  esr_member_id: nil,
)
file.add_record record2

# generate the LSV+ file and return it as a string
file.to_s
# => "8750P201601071337 2016010642   WTAGI0000001WT001CHF000001337,42CH9300762011623852957             Fancy AG                           Funnystreet 42                                                                                           123.456-78XY                      Debit AG                           Other Street 1337                  Somewhere City                                                        Invoice 133 via BDD                                                                                                                         A200002000000004443332000061133742   8750P201601071337 201601061337 WTAGI0000002WT001CHF000000042,10CH9300762011623852957             Fancy AG                           Funnystreet 42                                                                                           455.24401-AB                      Customer 77                        Bubu Av                            New Lala City                                                         Invoice 42 via BDD                                                                                                                          B030000SWAGFEEFORYOLO                890020160106WTAGI0000002CHF000001379,52"
```
