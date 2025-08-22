#!/usr/bin/env python3
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px

# 1. 读取数据
df = pd.read_csv('Fig.5f_vfg_energy.txt', sep='\t')  # 包含 source, activity, type 三列

# 2. 统计每条流的权重
links1 = df.groupby(['source', 'activity']).size().reset_index(name='count')
links2 = df.groupby(['activity', 'type']).size().reset_index(name='count')

# 3. 构造节点列表 & 索引映射
labels = pd.concat([links1['source'], links1['activity'], links2['type']]) \
           .drop_duplicates().tolist()
idx = {label: i for i, label in enumerate(labels)}

# 4. 构造三元组
sources, targets, values = [], [], []
for _, row in links1.iterrows():
    sources.append(idx[row['source']])
    targets.append(idx[row['activity']])
    values.append(row['count'])
for _, row in links2.iterrows():
    sources.append(idx[row['activity']])
    targets.append(idx[row['type']])
    values.append(row['count'])

# 5. 分阶段计算总流量
total_stage1 = links1['count'].sum()  # Genus → Activity
total_stage2 = links2['count'].sum()  # Activity → Type

# 6. 分阶段统计每个节点的流量
stage1_source_counts   = links1 .groupby('source'  )['count'].sum().to_dict()
stage1_activity_counts = links1 .groupby('activity')['count'].sum().to_dict()
stage2_type_counts     = links2 .groupby('type'    )['count'].sum().to_dict()

# 7. 构造带数量和百分比的 node_labels
node_labels = []
for lab in labels:
    if lab in stage1_source_counts:
        cnt = stage1_source_counts[lab]
        pct = cnt / total_stage1 * 100
    elif lab in stage1_activity_counts:
        cnt = stage1_activity_counts[lab]
        pct = cnt / total_stage1 * 100
    elif lab in stage2_type_counts:
        cnt = stage2_type_counts[lab]
        pct = cnt / total_stage2 * 100
    else:
        cnt, pct = 0, 0
    node_labels.append(f"{lab}\n{cnt} ({pct:.1f}%)")

# 8. 构造带百分比的 link_labels（相对于所有流量）
total_flow = sum(values)
link_labels = [f"{v} ({v/total_flow*100:.1f}%)" for v in values]

# 9. 指定节点和流线颜色——流线跟随 source 节点
palette     = px.colors.qualitative.Plotly
node_colors = [palette[i % len(palette)] for i in range(len(labels))]
link_colors = [node_colors[src] for src in sources]

# 10. 绘制 Sankey 图
fig = go.Figure(go.Sankey(
    node = dict(
        label     = node_labels,
        color     = node_colors,
        pad       = 15,
        thickness = 20
    ),
    link = dict(
        source        = sources,
        target        = targets,
        value         = values,
        label         = link_labels,
        color         = link_colors,
        hovertemplate = '%{label}<extra></extra>'
    )
))

fig.update_layout(
    title_text="Genus → Type  → Subype Sankey\n(节点／流量：数量 (百分比))",
    font_size=12
)

# 11. 导出为 PDF（需要提前安装 kaleido：pip install kaleido）
fig.write_image("vfg_sankey.pdf", format="pdf", width=1200, height=800)

