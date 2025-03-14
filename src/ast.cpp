/* Copyright (c) 2012, Achilleas Margaritis, modified by Li Jin
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/

#include <cassert>

#include "ast.hpp"

namespace parserlib {

traversal ast_node::traverse(const std::function<traversal(ast_node*)>& func) {
	return func(this);
}

ast_node* ast_node::get_by_type_ids(int* begin, int* end) {
	ast_node* current = this;
	auto it = begin;
	while (it != end) {
		ast_node* findNode = nullptr;
		int i = *it;
		current->visit_child([&](ast_node* node) {
			if (node->get_id() == i) {
				findNode = node;
				return true;
			}
			return false;
		});
		if (findNode) {
			current = findNode;
		} else {
			current = nullptr;
			break;
		}
		++it;
	}
	return current;
}

bool ast_node::visit_child(const std::function<bool(ast_node*)>&) {
	return false;
}

/** Asks all members to construct themselves from the stack.
	The members are asked to construct themselves in reverse order.
	from a node stack.
	@param st stack.
*/
void ast_container::construct(ast_stack& st) {
	for (ast_member_vector::reverse_iterator it = m_members.rbegin();
		it != m_members.rend();
		++it) {
		ast_member* member = *it;
		member->construct(st);
	}
}

traversal ast_container::traverse(const std::function<traversal(ast_node*)>& func) {
	traversal action = func(this);
	switch (action) {
		case traversal::Stop: return traversal::Stop;
		case traversal::Return: return traversal::Continue;
		default: break;
	}
	const auto& members = this->members();
	for (auto member : members) {
		switch (member->get_type()) {
			case ast_holder_type::Pointer: {
				_ast_ptr* ptr = static_cast<_ast_ptr*>(member);
				if (ptr->get() && ptr->get()->traverse(func) == traversal::Stop) {
					return traversal::Stop;
				}
				break;
			}
			case ast_holder_type::List: {
				_ast_list* list = static_cast<_ast_list*>(member);
				for (auto obj : list->objects()) {
					if (obj->traverse(func) == traversal::Stop) {
						return traversal::Stop;
					}
				}
				break;
			}
		}
	}
	return traversal::Continue;
}

bool ast_container::visit_child(const std::function<bool(ast_node*)>& func) {
	const auto& members = this->members();
	for (auto member : members) {
		switch (member->get_type()) {
			case ast_holder_type::Pointer: {
				_ast_ptr* ptr = static_cast<_ast_ptr*>(member);
				if (ptr->get()) {
					if (func(ptr->get())) return true;
				}
				break;
			}
			case ast_holder_type::List: {
				_ast_list* list = static_cast<_ast_list*>(member);
				for (auto obj : list->objects()) {
					if (obj) {
						if (func(obj)) return true;
					}
				}
				break;
			}
		}
	}
	return false;
}

/** parses the given input.
	@param i input.
	@param g root rule of grammar.
	@param el list of errors.
	@param ud user data, passed to the parse procedures.
	@return pointer to ast node created, or null if there was an error.
		The return object must be deleted by the caller.
*/
ast_node* parse(input& i, rule& g, error_list& el, void* ud) {
	ast_stack st;
	if (!parse(i, g, el, &st, ud)) {
		for (auto node : st) {
			delete node;
		}
		st.clear();
		return nullptr;
	}
	assert(st.size() == 1);
	return st.front();
}

/** check if the start part of given input matches grammar.
	The parse procedures of each rule parsed are executed
	before this function returns, if parsing succeeds.
	@param i input.
	@param g root rule of grammar.
	@param ud user data, passed to the parse procedures.
	@return true on parsing success, false on failure.
*/
ast_node* start_with(input& i, rule& g, error_list& el, void* ud) {
	ast_stack st;
	if (!start_with(i, g, el, &st, ud)) {
		for (auto node : st) {
			delete node;
		}
		st.clear();
		return nullptr;
	}
	assert(st.size() == 1);
	return st.front();
}

} // namespace parserlib
