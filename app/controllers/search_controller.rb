class SearchController < ApplicationController
  before_action :require_user

  def index
    query = params[:q]

    search_options = {
      query: {
        function_score: {
          query: {
            multi_match: {
              query: query,
              fuzziness: 'AUTO',
              operator: 'and',
              fields: [
                'title^1.5',
                'content',
                'provider_display',
                'provider_name',
                'author_name',
                'keywords',
                'entities'              ]
            }
          },
          functions: [
            {
              filter: { term: { liked: true } },
              weight: 2
            },
            {
              filter: { term: { saved: true } },
              weight: 1.5
            },
            {
              filter: { term: { interesting: true } },
              weight: 1.5
            },
            {
              gauss: { updated_at: { scale: '4w' } }
            }
          ],
          score_mode: 'multiply'
        }
      },
      filter: { term: { user_id: current_user.id } }
    }

    @user_pages = UserPage.search(search_options).page(params[:page]).records

    respond_with(@user_pages)
  end
end
