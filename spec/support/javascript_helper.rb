def expect_no_page_reload
  page.evaluate_script "$(document.body).addClass('not-reloaded')"
  yield
  expect(page).to have_selector("body.not-reloaded"), "Page should not reload"
end
