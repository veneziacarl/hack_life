class ReviewMailer < ApplicationMailer
  def new_review(review)
    @review = review
    mail(
      to: review.lifehack.creator.email,
      subject: "New Review for #{review.lifehack.title}"
    )
  end
end
