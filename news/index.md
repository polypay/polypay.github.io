---
layout: default
title: News
permalink: /news/
---

<div class="news-feed news-main">
	<h2>News</h2>

					{% for post in site.posts %}
						<div class="news-blurbs">
							<h3>{{ post.title }}</h3>
							<p class="date">{{ post.date | date: "%B %d, %Y"  }}</p>
							<div class="blurb">
								{% if post.blurb %}
									{{ post.blurb }} <a href="{{post.url}}"><i>  Read more...</i></a>
								{% else %}
									{{ post.content }}
								{% endif %}
							</div>
						</div>
					{% endfor %}
</div>
