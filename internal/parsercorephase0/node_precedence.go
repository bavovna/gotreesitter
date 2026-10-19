package parsercorephase0

import (
	"errors"
	"math"
)

// Common maxima share the existing lineage record without increasing its
// width. One value selects full-width storage; arithmetic stays int64.
const wideNodePrecedence int16 = math.MinInt16

var errMissingWideNodePrecedence = errors.New("parser-core phase zero: missing wide node precedence")

func inlineNodePrecedence(value int64) int16 {
	inline := int16(value)
	if int64(inline) != value || inline == wideNodePrecedence {
		return wideNodePrecedence
	}
	return inline
}

func (c *Core) storedNodePrecedence(id NodeID) (int64, error) {
	if uint64(id)-1 >= uint64(len(c.nodeLineages)) {
		return 0, errMissingWideNodePrecedence
	}
	inline := c.nodeLineages[id-1].precedenceInline
	if inline != wideNodePrecedence {
		return int64(inline), nil
	}
	if uint64(id)-1 >= uint64(len(c.nodePrecedenceWide)) {
		return 0, errMissingWideNodePrecedence
	}
	return c.nodePrecedenceWide[id-1], nil
}

// Wide storage is allocated only when needed. Dense NodeID indexing keeps the
// exceptional read constant-time and bounds its capacity by the node arena.
// Published entries never change; transaction marks truncate the logical end.
func (c *Core) storeWideNodePrecedence(id NodeID, value int64) {
	needed := int(id)
	if cap(c.nodePrecedenceWide) < needed {
		values := make([]int64, needed, cap(c.nodes))
		copy(values, c.nodePrecedenceWide)
		c.nodePrecedenceWide = values
	} else if len(c.nodePrecedenceWide) < needed {
		c.nodePrecedenceWide = c.nodePrecedenceWide[:needed]
	}
	c.nodePrecedenceWide[needed-1] = value
}
