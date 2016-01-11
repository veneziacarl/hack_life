class VoteMailer < ApplicationMailer
  def new_vote(vote)
    @vote = vote
    mail(
      to: vote.review.creator.email,
      subject: "New vote for your review on #{vote.review.lifehack.title}"
    )
  end
end
