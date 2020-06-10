//
//  Followers.swift
//  App
//
//  Created by Pedro L. Diaz Montilla on 06/06/2020.
//

import Foundation
import Vapor

struct FollowersResponse: Content {
	var next_cursor: Int
	var next_cursor_str: String
	var previous_cursor: Int
	var previous_cursor_str: String
	var total_count: Int?
	var users: [Follower]
}

struct Follower: Content {
	var blocked_by: String?
	var blocking: String?
	var contributors_enabled: Bool
	var created_at: String
	var default_profile: Bool
	var default_profile_image: Bool
	var description: String
	var favourites_count: Int
	var follow_request_sent: String?
	var followers_count: Int
	var following: String?
	var friends_count: Int
	var geo_enabled: Bool
	var has_extended_profile: Bool
	var id: Int
	var id_str: String
	var is_translation_enabled: Bool
	var is_translator: Bool
	var lang: String?
	var listed_count: Int
	var location: String
	var muting: String?
	var name: String
	var notifications: String?
	var profile_background_color: String
	var profile_background_image_url: String?
	var profile_background_image_url_https: String?
	var profile_background_tile: Bool
	var profile_banner_url: String?
	var profile_image_url: String?
	var profile_image_url_https: String
	var profile_link_color: String
	var profile_sidebar_border_color: String
	var profile_sidebar_fill_color: String
	var profile_text_color: String
	var profile_use_background_image: Bool
	var protected: Bool
	var screen_name: String
	var statuses_count: Int
	var time_zone: String?
	var translator_type: String
	var url: String?
	var utc_offset: String?
	var verified: Bool
	
}
