class TopicsController < ApplicationController
  before_action :configure_ab_response, if: :page_in_ab_test?, only: [:show]

  def index
    topic = Topic.find(request.path)
    setup_content_item_and_navigation_helpers(topic)

    render :index, locals: {
      topic: topic,
      is_page_under_ab_test: false,
      navigation_page_type: 'Topic Index'
    }
  end

  def show
    taxon_resolver = TaxonRedirectResolver.new(
      ab_variant,
      page_is_in_ab_test: page_in_ab_test?,
      map_to_taxon: top_level_redirect
    )

    if taxon_resolver.redirect?
      redirect_to(
        controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path,
        anchor: taxon_resolver.fragment
      )
    else
      topic = Topic.find(request.path)
      setup_content_item_and_navigation_helpers(topic)

      render :index, locals: {
        topic: topic,
        ab_variant: ab_variant,
        is_page_under_ab_test: page_in_ab_test?,
        legacy_navigation_analytics_identifier: legacy_navigation_analytics_identifier,
        navigation_page_type: 'First Level Topic'
      }
    end
  end

private

  def legacy_navigation_analytics_identifier
    top_level_redirect.split('/').first if page_in_ab_test?
  end

  def page_in_ab_test?
    top_level_redirect.present?
  end

  def top_level_redirect
    redirects[params[:topic_slug]]
  end

  def redirects
    Rails.application.config_for(:navigation_redirects)["topics"]
  end
end
