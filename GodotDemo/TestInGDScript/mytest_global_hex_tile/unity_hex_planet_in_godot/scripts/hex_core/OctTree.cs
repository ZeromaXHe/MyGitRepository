using System.Collections.Generic;
using Godot;

public class OctTree<K>
{
    public const int MaxDepth = 5;
    public const int MaxPointsPerLeaf = 6;

    private readonly Vector3 _backBottomLeft;
    private Vector3 _frontUpperRight;
    private readonly Vector3 _center;
    private readonly Vector3 _size;
    private readonly Dictionary<K, Vector3> _points;
    private readonly int _depth = 0;
    private bool _split = false;

    private OctTree<K> _bblOctTree = null;
    private OctTree<K> _fblOctTree = null;
    private OctTree<K> _btlOctTree = null;
    private OctTree<K> _ftlOctTree = null;
    private OctTree<K> _bbrOctTree = null;
    private OctTree<K> _fbrOctTree = null;
    private OctTree<K> _btrOctTree = null;
    private OctTree<K> _ftrOctTree = null;

    public OctTree(Vector3 backBottomLeft, Vector3 frontUpperRight, int depth) : this(backBottomLeft, frontUpperRight)
    {
        this._depth = depth;
    }

    public OctTree(Vector3 backBottomLeft, Vector3 frontUpperRight)
    {
        _frontUpperRight = frontUpperRight;
        _backBottomLeft = backBottomLeft;
        _center = (frontUpperRight + backBottomLeft) / 2.0f;
        _size = frontUpperRight - backBottomLeft;

        _points = new Dictionary<K, Vector3>();
    }

    private void Split()
    {
        _split = true;

        _bblOctTree = new OctTree<K>(_backBottomLeft, _center, _depth + 1);
        _fblOctTree = new OctTree<K>(_backBottomLeft + (Vector3.Forward * (_size.Z / 2)),
            _center + (Vector3.Forward * (_size.Z / 2)), _depth + 1);
        _btlOctTree = new OctTree<K>(_backBottomLeft + (Vector3.Up * (_size.Y / 2)),
            _center + (Vector3.Up * (_size.Y / 2)), _depth + 1);
        _ftlOctTree = new OctTree<K>(_backBottomLeft + (Vector3.Up * (_size.Y / 2)) + (Vector3.Forward * (_size.Z / 2)),
            _center + (Vector3.Up * (_size.Y / 2)) + (Vector3.Forward * (_size.Z / 2)), _depth + 1);
        _bbrOctTree = new OctTree<K>(_backBottomLeft + (Vector3.Right * (_size.X / 2)),
            _center + (Vector3.Right * (_size.X / 2)), _depth + 1);
        _fbrOctTree =
            new OctTree<K>(_backBottomLeft + (Vector3.Forward * (_size.Z / 2)) + (Vector3.Right * (_size.X / 2)),
                _center + (Vector3.Forward * (_size.Z / 2)) + (Vector3.Right * (_size.X / 2)), _depth + 1);
        _btrOctTree = new OctTree<K>(_backBottomLeft + (Vector3.Up * (_size.Y / 2)) + (Vector3.Right * (_size.X / 2)),
            _center + (Vector3.Up * (_size.Y / 2)) + (Vector3.Right * (_size.X / 2)), _depth + 1);
        _ftrOctTree = new OctTree<K>(
            _backBottomLeft + (Vector3.Up * (_size.Y / 2)) + (Vector3.Forward * (_size.Z / 2)) +
            (Vector3.Right * (_size.X / 2)),
            _center + (Vector3.Up * (_size.Y / 2)) + (Vector3.Forward * (_size.Z / 2)) +
            (Vector3.Right * (_size.X / 2)), _depth + 1);

        foreach (KeyValuePair<K, Vector3> kvp in _points)
        {
            InsertPointInternally(kvp.Key, kvp.Value);
        }

        _points.Clear();
    }

    private void InsertPointInternally(K key, Vector3 pos)
    {
        if (pos.X > _center.X)
        {
            // Right
            if (pos.Y > _center.Y)
            {
                // Top
                if (pos.Z > _center.Z)
                {
                    // Front
                    _ftrOctTree.InsertPoint(key, pos);
                }
                else
                {
                    // Back
                    _btrOctTree.InsertPoint(key, pos);
                }
            }
            else
            {
                // Bottom
                if (pos.Z > _center.Z)
                {
                    // Front
                    _fbrOctTree.InsertPoint(key, pos);
                }
                else
                {
                    // Back
                    _bbrOctTree.InsertPoint(key, pos);
                }
            }
        }
        else
        {
            // Left
            if (pos.Y > _center.Y)
            {
                // Top
                if (pos.Z > _center.Z)
                {
                    // Front
                    _ftlOctTree.InsertPoint(key, pos);
                }
                else
                {
                    // Back
                    _btlOctTree.InsertPoint(key, pos);
                }
            }
            else
            {
                // Bottom
                if (pos.Z > _center.Z)
                {
                    // Front
                    _fblOctTree.InsertPoint(key, pos);
                }
                else
                {
                    // Back
                    _bblOctTree.InsertPoint(key, pos);
                }
            }
        }
    }

    public void InsertPoint(K key, Vector3 pos)
    {
        if (!_split && _points.Count < MaxPointsPerLeaf)
        {
            _points.Add(key, pos);
            return;
        }

        if (!_split && _depth >= MaxDepth)
        {
            // Can't split anymore, adding to list
            _points.Add(key, pos);
            return;
        }

        // Split
        if (!_split)
        {
            Split();
        }

        InsertPointInternally(key, pos);
    }

    public List<K> GetPoints(Vector3 center, Vector3 size)
    {
        List<K> ret = new List<K>();

        if (!BoxIntersectsBox(center, size, _center, _size))
        {
            return ret;
        }

        if (!_split)
        {
            foreach (KeyValuePair<K, Vector3> kvp in _points)
            {
                if (PointWithinBox(center, size, kvp.Value))
                {
                    ret.Add(kvp.Key);
                }
            }

            return ret;
        }

        ret.AddRange(_bblOctTree.GetPoints(center, size));
        ret.AddRange(_fblOctTree.GetPoints(center, size));
        ret.AddRange(_btlOctTree.GetPoints(center, size));
        ret.AddRange(_ftlOctTree.GetPoints(center, size));
        ret.AddRange(_bbrOctTree.GetPoints(center, size));
        ret.AddRange(_fbrOctTree.GetPoints(center, size));
        ret.AddRange(_btrOctTree.GetPoints(center, size));
        ret.AddRange(_ftrOctTree.GetPoints(center, size));

        return ret;
    }

    private bool BoxIntersectsBox(Vector3 boxACenter, Vector3 boxASize, Vector3 boxBCenter, Vector3 boxBSize)
    {
        return ((boxACenter.X - boxASize.X <= boxBCenter.X + boxBSize.X) &&
                (boxACenter.X + boxASize.X >= boxBCenter.X - boxBSize.X)) &&
               ((boxACenter.Y - boxASize.Y <= boxBCenter.Y + boxBSize.Y) &&
                (boxACenter.Y + boxASize.Y >= boxBCenter.Y - boxBSize.Y)) &&
               ((boxACenter.Z - boxASize.Z <= boxBCenter.Z + boxBSize.Z) &&
                (boxACenter.Z + boxASize.Z >= boxBCenter.Z - boxBSize.Z));
    }

    private bool PointWithinBox(Vector3 boxCenter, Vector3 boxSize, Vector3 point)
    {
        return (point.X <= boxCenter.X + boxSize.X) && (point.X >= boxCenter.X - boxSize.X) &&
               (point.Y <= boxCenter.Y + boxSize.Y) && (point.Y >= boxCenter.Y - boxSize.Y) &&
               (point.Z <= boxCenter.Z + boxSize.Z) && (point.Z >= boxCenter.Z - boxSize.Z);
    }
}