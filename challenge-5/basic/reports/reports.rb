# frozen_string_literal: true

# rubocop:disable Metrics/LineLength

require_relative 'states'
require_relative 'fixtures'

# Generates reports
module Reports
  include ReportStates
  include ReportFixtures

  def reports
    @template = '<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous"><title>{TITLE}</title></head>'
    @template += '<body style="padding: 1em"><div class="d-flex" style="height: 100px;"><div class="d-flex" style="width: 200px; border: 1px solid black; align-items: center; justify-content: center;">LOGO</div><div class="flex-fill h-100"><div class="d-flex h-100" style=" align-items: center; justify-content: center;"><h1>{TITLE}</h1></div></div></div>'
    @template += '<div>{BODY}</div><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script></body></html>'

    report_states
    report_fixtures
  end
end
