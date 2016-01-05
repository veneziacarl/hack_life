class LifehacksController <  ApplicationController

  def index
    @lifehacks = Lifehack.all.order(created_at: :desc) 
  end

end
